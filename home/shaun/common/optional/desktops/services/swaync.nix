{ pkgs, ... }:
{
  home.packages = [ pkgs.swaynotificationcenter ];

  # FIXME: Jank as fuck, potential issues?
  systemd.user.services.swaync = {
    Unit = {
      Description = "Sway Notifications Center";
      PartOf = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecStart = "/usr/bin/env ${pkgs.swaynotificationcenter}/bin/swaync";
      ExecReload = "${pkgs.swaynotificationcenter}/swaync-client --reload-config ; ${pkgs.swaynotificationcenter}/swaync-client --reload-css";
      RestartSec = 5;
      Restart = "always";
    };
  };
  home.file = {
    "config" = {
      text = ''
        {
          "$schema": "/etc/xdg/swaync/configSchema.json",
          "positionX": "right",
          "positionY": "top",
          "layer": "overlay",
          "control-center-layer": "top",
          "layer-shell": true,
          "cssPriority": "application",
          "control-center-margin-top": 0,
          "control-center-margin-bottom": 0,
          "control-center-margin-right": 0,
          "control-center-margin-left": 0,
          "notification-2fa-action": true,
          "notification-inline-replies": false,
          "notification-icon-size": 64,
          "notification-body-image-height": 100,
          "notification-body-image-width": 200,
          "timeout": 10,
          "timeout-low": 5,
          "timeout-critical": 0,
          "fit-to-screen": true,
          "control-center-width": 500,
          "control-center-height": 600,
          "notification-window-width": 500,
          "keyboard-shortcuts": true,
          "image-visibility": "when-available",
          "transition-time": 200,
          "hide-on-clear": false,
          "hide-on-action": true,
          "script-fail-notify": true,
          "scripts": {
            "example-script": {
              "exec": "${pkgs.coreutils-full}/bin/echo 'Do something...'",
              "urgency": "Normal"
            },
            "example-action-script": {
              "exec": "${pkgs.coreutils-full}/bin/echo 'Do something actionable!'",
              "urgency": "Normal",
              "run-on": "action"
            }
          },
          "notification-visibility": {
            "example-name": {
              "state": "muted",
              "urgency": "Low",
              "app-name": "Spotify"
            }
          },
          "widgets": [
            "inhibitors",
            "title",
            "dnd",
            "notifications"
          ],
          "widget-config": {
            "inhibitors": {
              "text": "Inhibitors",
              "button-text": "Clear All",
              "clear-all-button": true
            },
            "title": {
              "text": "Notifications",
              "clear-all-button": true,
              "button-text": "Clear All"
            },
            "dnd": {
              "text": "Do Not Disturb"
            },
            "label": {
              "max-lines": 5,
              "text": "Label Text"
            },
            "mpris": {
              "image-size": 96,
              "image-radius": 12
            }
          }
        }
      '';
      target = "/.config/swaync/config.json";
    };
    #"style" = {
    #  source = "${pkgs.swaync-catppuccin}/macchiato.css";
    #  target = "/.config/swaync/style.css";
    #};
  };
}