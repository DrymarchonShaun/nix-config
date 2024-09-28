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
  publicKey = configVars.gpgKey;
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

      #FIXME stage 4 - Re-enable signing. needs additional setup
      commit.gpgsign = true;
      gpg.format = "openpgp";
      user.signing.key = "${publicKey}";
      # Taken from https://github.com/clemak27/homecfg/blob/16b86b04bac539a7c9eaf83e9fef4c813c7dce63/modules/git/ssh_signing.nix#L14
      # gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.gnupg/allowed_signers";
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
  # home.file.".ssh/allowed_signers".text = ''
  #   ${publicGitEmail} ${lib.fileContents (configLib.relativeToRoot "hosts/common/users/${username}/keys/ssh/id_mimir.pub")}
  # '';
}
