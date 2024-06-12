{ pkgs, lib, ... }:
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
            notification = "󰂚<span foreground = 'red' > <sup></sup> </span> ";
            none = "󰂚 ";
            dnd-notification = "󰂛<span foreground='red'><sup></sup></span> ";
            dnd-none = "󰂛 ";
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
          format = "{name} {icon}";
          format-icons = {
            locked = "󰔡 ";
            unlocked = "󰨙 ";
          };
        };
        clock = {
          interval = 1;
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%a, %d %b, %I:%M:%S %p}";
        };
        pulseaudio = {
          reverse-scrolling = 1;
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}  ";
          format-bluetooth-muted = "{icon} 󰝟 ";
          format-muted = "{volume}% 󰝟 ";
          format-source = "󰍬 ";
          format-source-muted = "󰍭 ";
          format-icons = {
            headphone = "󰋋 ";
            headset = "󰋎 ";
            default = [
              "󰕿 "
              "󰖀 "
              "󰕾 "
            ];
          };
          ignored-sinks = [
            "Easy Effects Sink"
          ];
          on-click = "${pkgs.pwvucontrol}/bin/pwvucontrol";
        };
        cpu = {
          format = "{usage}% 󰍛 ";
          format-alt = "{avg_frequency} GHz 󰍛 ";
          tooltip = true;
          interval = 1;
        };
        memory = {
          interval = 30;
          format = "{percentage}% 󰘚 ";
          format-alt = "{used} GB 󰘚 ";
        };
        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon4/temp1_input";
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [
            "󱃃 "
            "󰔏 "
            "󱃂 "
          ];
          tooltip = false;
          interval = 1;
        };
        "custom/fan" = {
          format = "{}% 󰈐 ";
          # exec = "${pkgs.fish}/bin/fish -c 'math -s0 (${pkgs.bat}/bin/bat /sys/class/hwmon/hwmon4/fan1_input)\" / 8800 * 100\"'";
          exec = "${pkgs.bash}/bin/bash -c 'echo $((($(${pkgs.bat}/bin/bat /sys/class/hwmon/hwmon4/fan1_input) * 100) / 8800))'";
          interval = 1;
          tooltip = false;
        };
        backlight = {
          device = "intel_backlight";
          format = "{percent}% {icon}";
          format-icons = [
            "󰃞 "
          ];
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂅 ";
          format-plugged = "{capacity}% 󰚥 ";
          format-alt = "{time} {icon}";
          format-icons = [
            "󰁺 "
            "󰁻 "
            "󰁼 "
            "󰁽 "
            "󰁾 "
            "󰁿 "
            "󰂀 "
            "󰂁 "
            "󰂂 "
            "󰁹 "
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
        font-family: Roboto Regular;
        min-height: 22px;
        font-size: 16px;
        text-shadow: none;
      }

      window#waybar {
        background: transparent;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces {
        margin-right: 0px;
        border-radius: 10px;
        transition: none;
        background: @surface0;
      }


      #workspaces button {
        padding-left: 4px;
        padding-right: 4px;
        text-shadow: inherit;
        color: @text;
        background: transparent;
        padding-top: 6px;
        padding-bottom: 6px;
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
        padding-left: 5px;
        padding-right: 4px;
        border-radius: 10px 0px 0px 10px;
        transition: none;
        color: @text;
        background: @surface0;
      }

        #custom-notification {
          padding-left: 6px;
          padding-right: 6px;
          border-radius: 0px 10px 10px 0px;
          transition: none;
          color: @text;
          background: @surface0;
        }

      #pulseaudio {
        padding-left: 11px;
        padding-right: 0px;
        border-radius: 10px 0px 0px 10px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #cpu {
        padding-left: 3px;
        padding-right: 0px;
        border-radius: 0px;
        color: @text;
        background: @surface0;
      }

      #temperature {
        padding-left: 5px;
        padding-right: 0px;
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
        padding-left: 3px;
        padding-right: 2px;
        border-radius: 0px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #custom-fan {
        padding-left: 3px;
        padding-right: 2px;
        border-radius: 0px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #keyboard-state {
        padding-left: 5px;
        padding-right: 0px;
        border-radius: 0px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #backlight {
        padding-left: 4px;
        padding-right: 4px;
        border-radius: 0px;
        transition: none;
        color: @text;
        background: @surface0;
      }

      #battery {
        padding-left: 4px;
        padding-right: 2px;
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
        padding-left: 0px;
        padding-right: 11px;
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
