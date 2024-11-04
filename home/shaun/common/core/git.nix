{
  pkgs,
  lib,
  config,
  configLib,
  configVars,
  ...
}:
let
  handle = configVars.handle;
  publicGitEmail = configVars.gitHubEmail;
  publicKey = "${config.home.homeDirectory}/.ssh/id_mimir.pub";
  username = configVars.username;
in
{
  home.packages = [ pkgs.lazygit ];
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = handle;
    userEmail = publicGitEmail;
    aliases = {
      stat = "status";
      pr = "!f() { git fetch -fu \${2:-$(git remote |grep ^upstream || echo origin)} refs/pull/$1/head:pr/$1 && git checkout pr/$1; }; f";
      pr-clean = "!git for-each-ref refs/heads/pr/* --format='%(refname)' | while read ref ; do branch=\${ref#refs/heads/} ; git branch -D $branch ; done";

      # For Bitbucket/Stash remotes
      spr = "!f() { git fetch -fu \${2:-$(git remote |grep ^upstream || echo origin)} refs/pull-requests/$1/from:pr/$1 && git checkout pr/$1; }; f";
    };
    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
        "ssh://git@gitlab.com" = {
          insteadOf = "https://gitlab.com";
        };
      };
      gpg.format = "ssh";
    };
    signing = {
      signByDefault = true;
      key = publicKey;
    };
    ignores = [
      ".csvignore"
      ".direnv"
      "result"
    ];
  };
  # NOTE: To verify github.com update commit signatures, you need to manually import
  # https://github.com/web-flow.gpg... would be nice to do that here
}
