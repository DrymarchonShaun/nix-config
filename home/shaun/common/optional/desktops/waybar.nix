{ pkgs, lib, ... }:
let
  # use U+2004 between text and icons
  smallSpace = ''<span font="Roboto"> </span>'';
  # offset char by rise
  iconOffset = rise: char: ''<span rise="${rise}">${char} </span>'';
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
        margin = "10 10 0 10";
        modules-left = [
          "sway/workspaces"
        ];
        modules-center = [
          "clock"
          "custom/notification"
        ];
        modules-right = [
          "pulseaudio"
          "cpu"
          "memory"
          "temperature"
          "custom/fan"
          "keyboard-state"
          "backlight"
          "battery"
          "tray"
        ];
        "sway/workspaces" = {
          format = "{name}";
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
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "<span text_transform=\"uppercase\">{name}</span>${smallSpace}{icon} ";
          format-icons = {
            locked = "󰔡 ";
            unlocked = "󰨙 ";
          };
        };
        clock = {
          interval = 1;
          format = "<span text_transform=\"uppercase\">{:%a, %d %b, %I:%M:%S %p}</span>";
        };
        pulseaudio = {
          reverse-scrolling = 1;
          format = "{volume}%${smallSpace}{icon}";
          format-muted = "{volume}%${smallSpace}${iconOffset "1pt" "󰝟"}";
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
        cpu = {
          format = "{usage}%${smallSpace}${iconOffset "1pt" "󰚗"}";
          format-alt = "{avg_frequency}GHz${smallSpace}${iconOffset "1pt" "󰚗"}";
          tooltip = true;
          interval = 1;
        };
        memory = {
          interval = 30;
          format = "{percentage}%${smallSpace}${iconOffset "1pt" "󰍛"}";
          format-alt = "{used}GB${smallSpace}${iconOffset "1pt" "󰍛"}";
        };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C${smallSpace}{icon}";
          format-icons = [
            (iconOffset "1pt" "󱃃")
            (iconOffset "1pt" "󰔏")
            (iconOffset "1pt" "󱃂")
            (iconOffset "1pt" "󰸁")
          ];
          tooltip = false;
          interval = 1;
        };
        backlight = {
          device = "intel_backlight";
          format = "{percent}%${smallSpace}{icon}";
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
          format = "{capacity}%${smallSpace}{icon}";
          format-charging = "{capacity}%${smallSpace}${iconOffset "1pt" "󰂄"}";
          format-plugged = "{capacity}%${smallSpace}${iconOffset "1pt" "󰚥"}";
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
        tray = {
          icon-size = 16;
          spacing = 4;
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        /* `otf-font-awesome` is required to be installed for icons */
        font-family: "Roboto Mono", "Symbols Nerd Font Mono";
        font-weight: normal;
        min-height: 22px;
        font-size: 17px;
        text-shadow: none;
        padding-top: 2px;
        padding-bottom: 2px;
      }
    
      window#waybar {
        background: transparent;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #spaced {
          letter-spacing: 0.25em;
      }

      #workspaces {
        margin-right: 0px;
        border-radius: 10px;
        transition: none;
        background: @surface0;
      }


      #workspaces button {
        padding-left: 0.5em;
        padding-right: 0.5em;
        text-shadow: inherit;
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
        box-shadow: 2px 2px 2px 2px;
        border-radius: 1em;
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
        transition: none;
        box-shadow: inherit;
        text-shadow: inherit;
        border-radius: inherit;
        color: @surface0;
        background: @blue;
      }

      #mode {
        border-radius: 10px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #clock {
        padding-left: 0.5em;
        padding-right: 0.5em;
        border-radius: 10px 0px 0px 10px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #custom-notification {
        padding-left: 0.25em;
        padding-right: 0.5em;
        border-radius: 0px 10px 10px 0px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #pulseaudio {
        padding-left: 0.5em;
        padding-right: 0.2em;
        border-radius: 10px 0px 0px 10px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #cpu {
        padding-left: 0.2em;
        padding-right: 0.2em;
        border-radius: 0px;
        color: @text;
        background: @surface0;
      }

      #temperature {
        padding-left: 0.2em;
        padding-right: 0.2em;
        border-radius: 0px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #temperature.critical {
        background: @red;
        color: @surface0;
      }

      #memory {
        padding-left: 0.2em;
        padding-right: 0.2em;
        border-radius: 0px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #custom-fan {
        padding-left: 0.2em;
        padding-right: 0.2em;
        border-radius: 0px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #keyboard-state {
        padding-left: 0.2em;
        padding-right: 0.2em;
        border-radius: 0px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #backlight {
        padding-left: 0.2em;
        padding-right: 0.2em;
        border-radius: 0px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #battery {
        padding-left: 0.2em;
        padding-right: 0.2em;
        border-radius: 0px;
        transition: none;
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
        padding-left: 0.2em;
        padding-right: 0.5em;
        border-radius: 0px 10px 10px 0px;
        transition: none;
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
