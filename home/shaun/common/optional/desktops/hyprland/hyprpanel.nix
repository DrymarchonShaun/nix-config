{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];
  options = {
    programs.hyprpanel.hasBattery = lib.mkEnableOption "Enables battery widget";
  };
  config = {

    programs.hyprpanel = {
      enable = true;
      hyprland.enable = true;
      overwrite.enable = true;

      theme = "catppuccin_macchiato";

      layout = {
        "bar.layouts" = {
          "*" = {
            left = [
              "dashboard"
              "workspaces"
              "windowtitle"
            ];
            middle = [ "media" ];
            right = [
              "volume"
              "clock"
              "notifications"
            ];
          };
          "0" = {
            left = [
              "dashboard"
              "workspaces"
              "windowtitle"
            ];
            middle = [ "media" ];
            right = [
              "volume"
              "network"
              "bluetooth"
              (lib.mkIf config.programs.hyprpanel.hasBattery "battery")
              "systray"
              "clock"
              "notifications"
            ];
          };
        };
      };

      settings = {

        theme = {
          font.name = "Inter";
          bar.outer_spacing = "0.5em";
        };

        bar = {
          launcher.autoDetectIcon = true;
          network.truncation = false;
        };
        notifications.position = "top";
        menus = {
          clock.weather.enabled = false;
          dashboard = {
            directories.enabled = false;
            shortcuts = {
              left = {
                shortcut1 = {
                  command = "";
                  icon = "";
                  tooltip = "";
                };
                shortcut2 = {
                  command = "";
                  icon = "";
                  tooltip = "";
                };
                shortcut3 = {
                  command = "";
                  icon = "";
                  tooltip = "";
                };
              };
            };
          };
        };
      };
    };
  };
}
