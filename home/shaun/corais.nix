{
  lib,
  configVars,
  config,
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
    common/optional/games
    common/optional/media
    common/optional/tools

    common/optional/desktops

  ];

  home.sessionVariables = {
    GDK_DPI_SCALE = 1.15;
  };
  wayland.windowManager.sway = {
    config = {
      workspaceOutputAssign = [
        {
          output = "DP-1";
          workspace = "1:1";
        }
        {
          output = "DP-1";
          workspace = "2:2";
        }
        {
          output = "DP-1";
          workspace = "3:3";
        }
        {
          output = "DP-1";
          workspace = "4:4";
        }
        {
          output = "DP-2";
          workspace = "11:F1";
        }
        {
          output = "DP-2";
          workspace = "12:F2";
        }
        {
          output = "DP-2";
          workspace = "13:F3";
        }
        {
          output = "DP-2";
          workspace = "14:F4";
        }
      ];
    };
  };
  programs.waybar.settings.mainBar."sway/workspaces"."persistent-workspaces" = {
    "1:1" = [ "DP-1" ];
    "2:2" = [ "DP-1" ];
    "3:3" = [ "DP-1" ];
    "4:4" = [ "DP-1" ];
    "11:F1" = [ "DP-2" ];
    "12:F2" = [ "DP-2" ];
    "13:F3" = [ "DP-2" ];
    "14:F4" = [ "DP-2" ];
  };

  programs.waybar.settings.mainBar.temperature.hwmon-path = "/sys/class/hwmon/hwmon2/temp3_input";

  programs.foot.settings.main.font = lib.mkForce "JetBrains Mono:size=13,Symbols Nerd Font Mono:size=13";

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };
  # Disable impermanence
  #home.persistence = lib.mkForce { };

}
