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

      x = 0;
      y = 0;
      scale = 1.0;

      vrr = 0;
      primary = true;
      noBar = false;

      workspaces = [
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
        "10"
      ];
    }
    {
      name = "DP-2";

      width = 2560;
      height = 1440;
      # FIXME(hyprland): having both monitors set to 165 causes hyprland to freeze after dpms off
      refreshRate = 165;

      x = 2560;
      y = 0;
      scale = 1.0;

      vrr = 0;

      workspaces = [
        "11"
        "12"
        "13"
        "14"
        "15"
        "16"
        "17"
        "18"
        "19"
        "20"
        "21"
        "22"
      ];
    }
  ];
  home.sessionVariables = {
    GDK_DPI_SCALE = 1.15;
  };
  # TODO(wm migration): update this for hyprland
  programs.waybar.settings.mainBar = {
    outputs = [
      "DP-1"
      "DP-2"
    ];
  };

  programs.waybar.settings.mainBar.temperature.hwmon-path = "/sys/class/hwmon/hwmon2/temp3_input";
}
