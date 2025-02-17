{ ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/browsers
    common/optional/desktops # default is sway
    common/optional/development
    common/optional/comms
    common/optional/gaming
    common/optional/gaming/arma.nix
    common/optional/media
    common/optional/tools

    common/optional/atuin.nix
    common/optional/xdg.nix # file associations
    common/optional/sops.nix
  ];

  #
  # ========== Host-specific Monitor Spec ==========
  #
  # This uses the nix-config/modules/home-manager/montiors.nix module which defaults to enabled.
  # Your nix-config/home-manger/<user>/common/optional/desktops/foo.nix WM config should parse and apply these values to it's monitor settings
  # If on hyprland, use `hyprctl monitors` to get monitor info.
  # https://wiki.hyprland.org/Configuring/Monitors/
  #  ------   ------
  # | DP-1 | | DP-2 |
  #  ------   ------
  monitors = [
    {
      name = "DP-1";
      width = 2560;
      height = 1440;
      refreshRate = 165;
      noBar = false;
      scale = 1.0;
      x = 0;
      vrr = 0;
      primary = true;
    }
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      # FIXME(hyprland): having both monitors set to 165 causes hyprland to freeze after dpms off
      refreshRate = 165;
      scale = 1.0;
      x = 2560;
      vrr = 0;
    }
  ];
  home.sessionVariables = {
    GDK_DPI_SCALE = 1.15;
  };
  wayland.windowManager.hyprland = {
    settings = {
      workspace = [
        "1, defaultName:1, monitor:DP-1, persistent:true, default:true"

        "2, defaultName:2, monitor:DP-1, persistent:true"
        "3, defaultName:3, monitor:DP-1, persistent:true"
        "4, defaultName:4, monitor:DP-1, persistent:true"
        "5, defaultName:5, monitor:DP-1"
        "6, defaultName:6, monitor:DP-1"
        "7, defaultName:7, monitor:DP-1"
        "8, defaultName:8, monitor:DP-1"
        "9, defaultName:9, monitor:DP-1"
        "10, defaultName:0, monitor:DP-1"

        "11, defaultName:F1, monitor:DP-2, persistent:true, default:true"

        "12, defaultName:F2, monitor:DP-2, persistent:true"
        "13, defaultName:F3, monitor:DP-2, persistent:true"
        "14, defaultName:F4, monitor:DP-2, persistent:true"
        "15, defaultName:F5, monitor:DP-2"
        "16, defaultName:F6, monitor:DP-2"
        "17, defaultName:F7, monitor:DP-2"
        "18, defaultName:F8, monitor:DP-2"
        "19, defaultName:F9, monitor:DP-2"
        "20, defaultName:F10, monitor:DP-2"
        "21, defaultName:F11, monitor:DP-2"
        "22, defaultName:F12, monitor:DP-2"

      ];
    };
  };
  # TODO(wm migration): update this for hyprland
  programs.waybar.settings.mainBar = {
    outputs = [
      "DP-1"
      "DP-2"
    ];
    "hyprland/workspaces"."persistent-workspaces" = {
      # "1" = [ ];
      # "2" = [ ];
      # "3" = [ ];
      # "4" = [ ];
      # "11" = [ ];
      # "12" = [ ];
      # "13" = [ ];
      # "14" = [ ];
    };
  };

  programs.waybar.settings.mainBar.temperature.hwmon-path = "/sys/class/hwmon/hwmon2/temp3_input";
}
