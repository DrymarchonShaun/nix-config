{ pkgs, ... }:
{
  imports = [ ./discord.nix ];

  home.packages = builtins.attrValues {
    inherit (pkgs)

      #telegram-desktop
      #discord
      #slack
      ;
  };
}
