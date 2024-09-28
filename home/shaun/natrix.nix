{
  lib,
  pkgs,
  configVars,
  ...
}:
{
  imports = [
    #################### Required Configs ####################
    common/core # required

    #################### Host-specific Optional Configs ####################
    common/optional/browsers/brave.nix
    common/optional/browsers/firefox.nix
    common/optional/comms
    common/optional/dev/vscode.nix
    common/optional/games/heroic.nix
    common/optional/games/mangohud.nix
    common/optional/games/prismlauncher.nix
    common/optional/games/steam.nix
    common/optional/media
    common/optional/tools

    common/optional/desktops

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
          output = "HMDI-A-1";
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
          local PWM_PERCENT="$((($(${pkgs.bat}/bin/bat /sys/class/hwmon/hwmon4/pwm1) * 100) / 255))"
        local RPM="$(${pkgs.bat}/bin/bat /sys/class/hwmon/hwmon4/fan1_input)"
        echo -e "{\"text\": \"$PWM_PERCENT\", \"tooltip\": $RPM}"
      '';
    in
    {
      format = "{}% 󰈐 ";
      format-tooltip = "{} RPM";
      exec = "${waybar-fan}";
      interval = 1;
      tooltip = true;
    };

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };
  # Disable impermanence
  #home.persistence = lib.mkForce { };

}
