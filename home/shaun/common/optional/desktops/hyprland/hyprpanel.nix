{
  lib,
  config,
  ...
}:
{
  options = {
    programs.hyprpanel.hasBattery = lib.mkEnableOption "Enables battery widget";
  };
  config = {
    home.sessionVariables = {
      GRIMBLAST_HIDE_CURSOR = 0; # Fix hyprpanel crashing when using grimblast - see https://github.com/Jas-SinghFSU/HyprPanel/issues/888
    };

    programs.hyprpanel = {
      enable = true;
      systemd.enable = true;
      settings = {
        bar = {
          launcher.autoDetectIcon = true;
          network.truncation = false;
          layouts = {
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

        theme = {
          name = "catppuccin_macchiato";
          font.name = "Inter";
          bar.outer_spacing = "0.5em";
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
