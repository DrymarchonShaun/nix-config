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
      scale = 1.15;
      x = 0;
      workspace = "1";
      primary = true;
    }
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      refreshRate = 165;
      scale = 1.15;
      x = 2560;
      workspace = "F1";
    }
  ];

  wayland.windowManager.hyprland.config = {
    extraSessionCommands = ''
      "export GDK_DPI_SCALE=1.15"
    '';

    workspaceOutputAssign = [
      { output = "DP-1"; workspace = "1"; }
      { output = "DP-1"; workspace = "2"; }
      { output = "DP-1"; workspace = "3"; }
      { output = "DP-1"; workspace = "4"; }
      { output = "DP-2"; workspace = "F1"; }
      { output = "DP-2"; workspace = "F2"; }
      { output = "DP-2"; workspace = "F3"; }
      { output = "DP-2"; workspace = "F4"; }
    ];
  };



  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };
  # Disable impermanence
  #home.persistence = lib.mkForce { };

}
