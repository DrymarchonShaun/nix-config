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
    common/optional/desktops/sway

  ];

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      noBar = false;
      scale = 1;
      x = 0;
      primary = true;
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      scale = 1;
      x = 1920;
    }
  ];

  wayland.windowManager.sway = {
    # extraSessionCommands = [
    #   "export GDK_DPI_SCALE=1.15"
    # ];
    config = {
      workspaceOutputAssign = [
        { output = "eDP-1"; workspace = "1"; }
        { output = "eDP-1"; workspace = "2"; }
        { output = "eDP-1"; workspace = "3"; }
        { output = "HMDI-A-1"; workspace = "11:F1"; }
        { output = "DP-1"; workspace = "11:F1"; }
      ];
    };
  };
  programs.waybar.settings.mainBar."sway/workspaces"."persistent_workspaces" = {
    "1" = [ "eDP-1" ];
    "2" = [ "eDP-1" ];
    "3" = [ "eDP-1" ];
    "4" = [ "eDP-1" ];
    "11:F1" = [ "DP-1" "HDMI-A-1" ];

  };

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };
  # Disable impermanence
  #home.persistence = lib.mkForce { };

}