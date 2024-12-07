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

  wayland.windowManager.sway = {
    config = {
      workspaceOutputAssign = [
        {
          output = "eDP-1";
          workspace = "1:1";
        }
        {
          output = "eDP-1";
          workspace = "2:2";
        }
        {
          output = "eDP-1";
          workspace = "3:3";
        }
        {
          output = "HDMI-A-1";
          workspace = "11:F1";
        }
        {
          output = "DP-1";
          workspace = "11:F1";
        }
      ];
    };
  };
  programs.waybar.settings.mainBar."sway/workspaces"."persistent-workspaces" = {
    "1:1" = [ "eDP-1" ];
    "2:2" = [ "eDP-1" ];
    "3:3" = [ "eDP-1" ];
    "4:4" = [ "eDP-1" ];
    "11:F1" = [
      "DP-1"
      "HDMI-A-1"
    ];
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
