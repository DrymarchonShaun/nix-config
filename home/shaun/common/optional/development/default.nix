# Development utilities I want across all systems
{
  config,
  lib,
  pkgs,
  ...
}:
let
  #TODO: add codeberg email
  # publicGitEmail = config.hostSpec.email.gitHub;
  sshFolder = "${config.home.homeDirectory}/.ssh";
  publicKey =
    if config.hostSpec.useYubikey then "${sshFolder}/id_onlykey.pub" else "${sshFolder}/id_manu.pub";
  privateGitConfig = "${config.home.homeDirectory}/.config/git/gitconfig.private";
in
{
  imports = lib.custom.scanPaths ./.;

  home.packages = lib.flatten [
    (builtins.attrValues {
      inherit (pkgs)
        # Development
        direnv
        delta # diffing
        act # github workflow runner
        gh # github cli
        glab # gitlab cli
        yq-go # Parser for Yaml and Toml Files, that mirrors jq

        # nix
        nixpkgs-review

        # networking
        nmap

        # Diffing
        difftastic

        # serial debugging
        screen

        # Standard man pages for linux API
        man-pages
        man-pages-posix
        ;
    })

    #    (lib.optionals pkgs.stdenv.isLinux (
    #      builtins.attrValues {
    #        inherit (pkgs)
    #          gdb
    #          pwndbg
    #          ;
    #      }
    #    ))
  ];

  #NOTE: Already enabled earlier, this is just extra config
  programs.git = {
    userName = config.hostSpec.handle;
    userEmail = config.hostSpec.email.user;

    # Enforce SSH to leverage yubikey
    extraConfig = {
      # breaks up arrow through previous commit messages in lazygit
      # log.showSignature = "true";
      init.defaultBranch = "main";
      pull.rebase = "true";

      # Don't warn on empty git add calls. Because of "git re-commit" automation
      advice.addEmptyPathspec = false;

      url = { };

      includeIf."gitdir:${config.home.homeDirectory}/.src/".path = privateGitConfig;

      # FIXME: Testing difftastic from https://github.com/thled/nix-config
      diff.tool = "difftastic";
      difftool = {
        prompt = "false";
        difftastic.cmd = "difft \"$LOCAL\" \"$REMOTE\"";
      };

      commit.gpgsign = true;
      gpg.format = "ssh";

      # Signing key for non-yubikey hosts
      user.signingkey = "${publicKey}";

      # Taken from https://github.com/clemak27/homecfg/blob/16b86b04bac539a7c9eaf83e9fef4c813c7dce63/modules/git/ssh_signing.nix#L14
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
    };
    signing = {
      signByDefault = true;
      key = publicKey;
    };
  };

  # NOTE: To verify github.com update commit signatures, you need to manually import
  # https://github.com/web-flow.gpg... would be nice to do that here
  home.file.".ssh/allowed_signers".text = ''
    ${config.hostSpec.email.user} ${lib.fileContents (lib.custom.relativeToRoot "hosts/common/users/primary/keys/id_mimir.pub")}
    ${config.hostSpec.email.user} ${lib.fileContents (lib.custom.relativeToRoot "hosts/common/users/primary/keys/id_emoryi.pub")}
    ${config.hostSpec.email.user} ${lib.fileContents (lib.custom.relativeToRoot "hosts/common/users/primary/keys/id_dione.pub")}
  '';

  home.file."${privateGitConfig}".text = ''
    [user]
      name = "${config.hostSpec.handle}"
      email = ${config.hostSpec.email.user}
  '';
}
