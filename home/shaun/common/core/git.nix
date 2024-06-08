{ pkgs, lib, config, configVars, configLib, ... }:
{
  home.packages = [ pkgs.lazygit ];
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = configVars.handle;
    # Not best practice, but this is primarily being hidden from the open internet - for more information see https://github.com/ryantm/agenix?tab=readme-ov-file#builtinsreadfile-anti-pattern
    userEmail = configLib.readFile config.sops.secrets."${configVars.username}/email".path;
    aliases = {
      stat = "status";
    };
    extraConfig = {
      init.defaultBranch = "main";
      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
        "ssh://git@gitlab.com" = {
          insteadOf = "https://gitlab.com";
        };
      };

      # user.signing.key = "41B7B2ECE0FAEF890343124CE8AA1A8F75B56D39";
      #TODO sops - Re-enable once sops setup complete
      # commit.gpgSign = false;
      # gpg.program = "${config.programs.gpg.package}/bin/gpg2";
    };
    # enable git Large File Storage: https://git-lfs.com/
    # lfs.enable = true;
    ignores = [ ".direnv" "result" ];
  };
} 
