#TODO: add better rules for forcing ssh as per fb
{
  pkgs,
  lib,
  config,
  ...
}:
let
  handle = config.hostSpec.handle;
  publicGitEmail = config.hostSpec.email.gitHub;
  publicKey = "${config.home.homeDirectory}/.ssh/id_mimir.pub";
in
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = handle;
    userEmail = publicGitEmail;
    aliases = {
      stat = "status";
      pr = "!f() { git fetch -fu \${2:-$(git remote |grep ^upstream || echo origin)} refs/pull/$1/head:pr/$1 && git checkout pr/$1; }; f";
      pr-clean = "!git for-each-ref refs/heads/pr/* --format='%(refname)' | while read ref ; do branch=\${ref#refs/heads/} ; git branch -D $branch ; done";

    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = "true";
      url = {
        # Only force ssh if it's not minimal

        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
        "ssh://git@gitlab.com" = {
          insteadOf = "https://gitlab.com";
        };
      };

      commit.gpgsign = true;
      gpg.format = "ssh";
      # Taken from https://github.com/clemak27/homecfg/blob/16b86b04bac539a7c9eaf83e9fef4c813c7dce63/modules/git/ssh_signing.nix#L14
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";

      # save.directory = "${config.home.homeDirectory}/sync/obsidian-vault-01/wiki";
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
  home.file.".ssh/allowed_signers".text = ''
    ${publicGitEmail} ${lib.fileContents (lib.custom.relativeToRoot "hosts/common/users/primary/keys/id_mimir.pub")}
  '';
}
