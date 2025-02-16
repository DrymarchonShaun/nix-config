{ pkgs, ... }:
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

  wayland.windowManager.hyprland = {
    settings = {
      workspace = [
        "1, defaultName:1, monitor:eDP-1, persistent:true, default:true"
        "2, defaultName:2, monitor:eDP-1, persistent:true"
        "3, defaultName:3, monitor:eDP-1, persistent:true"
        "4, defaultName:4, monitor:eDP-1, persistent:true"
        "5, defaultName:5, monitor:eDP-1"
        "6, defaultName:6, monitor:eDP-1"
        "7, defaultName:7, monitor:eDP-1"
        "8, defaultName:8, monitor:eDP-1"
        "9, defaultName:9, monitor:eDP-1"
        "10, defaultName:0, monitor:eDP-1"

        "11, defaultName:F1"

        "12, defaultName:F2"
        "13, defaultName:F3"
        "14, defaultName:F4"
        "15, defaultName:F5"
        "16, defaultName:F6"
        "17, defaultName:F7"
        "18, defaultName:F8"
        "19, defaultName:F9"
        "20, defaultName:F10"
        "21, defaultName:F11"
        "22, defaultName:F12"
      ];
    };
  };
  # TODO(wm migration): update this for hyprland
  programs.waybar.settings.mainBar = {
    outputs = [
      "eDP-1"
      "HDMI-A-1"
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
  programs.waybar.settings.mainBar.temperature.hwmon-path = "/sys/class/hwmon/hwmon4/temp1_input";

  programs.waybar.settings.mainBar."custom/fan" =
    let
      waybar-fan = pkgs.writeShellScript "waybar-fan" ''
        PWM_PERCENT="$((($(${pkgs.bat}/bin/bat /sys/class/hwmon/hwmon4/pwm1) * 100) / 255))"
        RPM="$(${pkgs.bat}/bin/bat /sys/class/hwmon/hwmon4/fan1_input)"
        echo -e "{\"text\": \"$PWM_PERCENT\", \"tooltip\": \"$RPM RPM\"}" | ${pkgs.jq}/bin/jq --compact-output --unbuffered
      '';
    in
    {
      format = "{}% 󰈐 ";
      exec = "${waybar-fan}";
      return-type = "json";
      interval = 1;
      tooltip = true;
    };
}
