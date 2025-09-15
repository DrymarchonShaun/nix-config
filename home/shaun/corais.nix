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
    common/optional/desktops/hyprland
    common/optional/desktops/rofi.nix
    # common/optional/desktops/sway
    common/optional/desktops/common/ghostty.nix
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
