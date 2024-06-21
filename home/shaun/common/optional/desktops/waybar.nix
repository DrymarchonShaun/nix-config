{ pkgs, lib, ... }:
let
  # use U+2004 between text and icons
  smallSpace = ''<span font="Roboto"> </span>'';
  # offset char by rise
  iconOffset = rise: char: ''<span  font="Symbols Nerd Font Mono" rise="${rise}">${char} </span>'';
in
{
  # Let it try to start a few more times
  systemd.user.services.waybar = {
    Unit.StartLimitBurst = 30;
    Service.RestartSec = 5;
  };
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    systemd.enable = true;
    systemd.target = "graphical-session.target";
    catppuccin.enable = true;
    settings = {
      mainBar = {
        layer = "bottom";
        margin = "20 20 0 20";
        modules-left = [
          "sway/workspaces"
        ];
        modules-center = [
          "clock"
          "custom/notification"
        ];
        modules-right = [
          "cpu"
          "memory"
          "temperature"
          "custom/fan"
          "keyboard-state"
          "backlight"
          "battery"
          "pulseaudio"
          "tray"
        ];


        ########## Left Modules ##########
        "sway/workspaces" = {
          format = "{name}";
        };



        ########## Center Modules ##########
        clock = {
          interval = 1;
          format = "<span text_transform=\"uppercase\">{:%a,${smallSpace}%d${smallSpace}%b,${smallSpace}%I:%M:%S${smallSpace}%p}</span>";
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = (iconOffset "1pt" "󱅫");
            none = (iconOffset "1pt" "󰂚");
            dnd-notification = (iconOffset "1pt" "󰂛");
            dnd-none = (iconOffset "1pt" "󰂛");
          };
          return-type = "json";
          exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
          on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
          escape = true;
        };



        ########## Right Modules ##########
        cpu = {
          format = "{usage:2}%${smallSpace}${iconOffset "1pt" "󰚗"}";
          format-alt = "{avg_frequency:>}GHz${smallSpace}${iconOffset "1pt" "󰚗"}";
          tooltip = true;
          interval = 1;
        };

        memory = {
          interval = 30;
          format = "{percentage:2}%${smallSpace}${iconOffset "1pt" "󰍛"}";
          format-alt = "{used:>}GB${smallSpace}${iconOffset "1pt" "󰍛"}";
        };

        temperature = {
          critical-threshold = 80;
          format = "{temperatureC:2}°C${smallSpace}{icon}";
          format-icons = [
            (iconOffset "1pt" "󱃃")
            (iconOffset "1pt" "󱃃")
            (iconOffset "1pt" "󰔏")
            (iconOffset "1pt" "󰔏")
            (iconOffset "1pt" "󱃂")
            (iconOffset "1pt" "󱃂")
            (iconOffset "1pt" "󰸁")
            (iconOffset "1pt" "󰸁")
          ];
          tooltip = false;
          interval = 1;
        };

        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "<span text_transform=\"uppercase\">{name}</span>${smallSpace}{icon} ";
          format-icons = {
            locked = (iconOffset "1pt" "󰔡");
            unlocked = (iconOffset "1pt" "󰨙");
          };
        };

        backlight = {
          device = "intel_backlight";
          format = "{percent:2}%${smallSpace}{icon}";
          format-icons = [
            (iconOffset "1pt" "󰃞")
            (iconOffset "1pt" "󰃟")
            (iconOffset "1pt" "󰃠")
          ];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity:2}%${smallSpace}{icon}";
          format-charging = "{capacity:2}%${smallSpace}${iconOffset "1pt" "󰂄"}";
          format-plugged = "{capacity:2}%${smallSpace}${iconOffset "1pt" "󰚥"}";
          format-alt = "{time}${smallSpace}{icon}";
          format-icons = [
            (iconOffset "1pt" "󰁺")
            (iconOffset "1pt" "󰁻")
            (iconOffset "1pt" "󰁼")
            (iconOffset "1pt" "󰁽")
            (iconOffset "1pt" "󰁾")
            (iconOffset "1pt" "󰁿")
            (iconOffset "1pt" "󰂀")
            (iconOffset "1pt" "󰂁")
            (iconOffset "1pt" "󰂂")
            (iconOffset "1pt" "󰁹")
          ];
        };

        pulseaudio = {
          reverse-scrolling = 1;
          format = "{volume:2}%${smallSpace}{icon}";
          format-muted = "{volume:2}%${smallSpace}${iconOffset "1pt" "󰝟"}";
          format-source = (iconOffset "1pt" "󰍬");
          format-source-muted = (iconOffset "1pt" "󰍭");
          format-icons = {
            default = [
              (iconOffset "1pt" "󰕿")
              (iconOffset "1pt" "󰖀")
              (iconOffset "1pt" "󰕾")
            ];
          };
          ignored-sinks = [
            "Easy Effects Sink"
          ];
          on-click = "${pkgs.pwvucontrol}/bin/pwvucontrol";
        };

        tray = {
          icon-size = 16;
          spacing = 4;
        };
      };
    };
    style = ''
      * {
        font-family: "Roboto Mono", "Symbols Nerd Font Mono";
        font-weight: normal;
        font-size: 16px;
      }
    
      window#waybar {
        background: transparent;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces {
        border-radius: 10px;
        padding-left: 0em;
        padding-right: 0em;
        background: @surface0;
      }

      #workspaces button {
        padding-left: 0.5em;
        padding-right: 0.5em;
        color: @text;
        background: transparent;
      }

      #workspaces button.persistent {
        color: @overlay1;
      }

      #workspaces button.visible {
        color: @green;
      }

      #workspaces button.active {
        color: @text;
      }
      
      #workspaces button.focused {
        color: @blue;
      }

      #workspaces button.urgent {
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
        background: @red;
        color: @surface0;
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        border-radius: inherit;
        color: @surface0;
        background: @blue;
      }

      #clock {
        border-radius: 10px 0px 0px 10px;
        padding-left: 0.5em;
        padding-right: 0.25em;
        color: @text;
        background: @surface0;
      }

      #custom-notification {
        border-radius: 0px 10px 10px 0px;
        padding-left: 0.25em;
        padding-right: 0.5em;
        color: @text;
        background: @surface0;
      }

      #pulseaudio {
        border-radius: 0px 10px 10px 0px;
        padding-right: 0.5em;
        padding-left: 0em;
        color: @text;
        background: @surface0;
      }

      #cpu {
        border-radius: 10px 0px 0px 10px;
        padding-left: 0.5em;
        padding-right: 0.25em;
        color: @text;
        background: @surface0;
      }

      #temperature {
        padding-right: 0.25em;
        padding-left: 0.25em;
        color: @text;
        background: @surface0;
      }

      #temperature.critical {
        background: @red;
        color: @surface0;
      }

      #memory {
        padding-right: 0.25em;
        padding-left: 0.25em;
        color: @text;
        background: @surface0;
      }

      #custom-fan {
        padding-right: 0.25em;
        padding-left: 0.25em;
        color: @text;
        background: @surface0;
      }

      #keyboard-state {
        padding-left: 0.25em;
        color: @text;
        background: @surface0;
      }

      #backlight {
        color: @text;
        background: @surface0;
      }

      #battery {
        background: @surface0;
        color: @text;
      }

      #battery.warning:not(.charging) {
        background: @yellow;
        color: @surface0;
      }

      #battery.critical:not(.charging) {
        background: @red;
        color: @surface0;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #tray {
        border-radius: 10px;
        margin-left: 0.5em;
        padding-left: 0.5em;
        padding-right: 0.5em;
        color: @text;
        background: @surface0;
      }

      @keyframes blink {
        to {
          background: @text;
          color: #000000;
        }
      }
    '';
  };
}
