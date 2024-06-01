{ lib, configVars, ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/sops.nix
    common/optional/browsers/brave.nix
    common/optional/browsers/firefox.nix
    common/optional/comms/discord.nix
    common/optional/dev/vscode.nix
    common/optional/games/steam.nix
    common/optional/games/heroic.nix
    common/optional/media/calibre.nix
    common/optional/tools/eye-of-gnome.nix
    common/optional/tools/gimp.nix
    common/optional/tools/inkscape.nix
    common/optional/tools/libreoffice.nix
    common/optional/tools/wine.nix
    common/optional/tools/xdg.nix
    common/optional/tools/nemo.nix

    common/optional/desktops
    common/optional/desktops/hyprland

  ];

  monitors = [
    {
      name = "DP-1";
      width = 2560;
      height = 1440;
      refreshRate = 165;
      noBar = false;
      x = 0;
      workspace = "1";
      primary = true;
    }
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      refreshRate = 165;
      x = 2560;
      workspace = "F1";
    }
  ];

  wayland.windowManager.hyprland.settings.workspace = [
    "name:1,monitor:DP-1,default=true"
    "name:2,monitor:DP-1"
    "name:3,monitor:DP-1"
    "name:4,monitor:DP-1"
    "name:F1,monitor:DP-2,default=true"
    "name:F2,monitor:DP-2"
    "name:F3,monitor:DP-2"
    "name:F4,monitor:DP-2"
  ];



  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };
  # Disable impermanence
  #home.persistence = lib.mkForce { };

}
