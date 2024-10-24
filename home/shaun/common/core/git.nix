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
