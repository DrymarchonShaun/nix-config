{ pkgs, ... }:
{
  imports = [ ./discord.nix ];

  home.packages = builtins.attrValues {
    inherit (pkgs)

      # signal-desktop
      # telegram-desktop
      # discord
      # slack
      ;
  };
}
