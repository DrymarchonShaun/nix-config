{ pkgs, lib, config, configVars, configLib, ... }:
{
  home.packages = [ pkgs.lazygit ];
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = configVars.handle;
    userEmail = configVars.gitHubEmail;
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
    };

    ignores = [ ".direnv" "result" ];
  };
} 
