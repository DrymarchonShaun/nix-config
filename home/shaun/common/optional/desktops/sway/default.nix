{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    # custom key binds
    ./binds.nix

    ########## Utilities ##########
    ../services/swaync.nix # Notification daemon
    ../services/clipboard.nix # Clipboard functionality
    ../waybar.nix # infobar
    ../swayidle.nix
    ../swaylock.nix
    ../rofi.nix
    ../tray.nix
    ../wayland.nix # various wayland utilities

  ];

  # NOTE: xdg portal package is currently set in /hosts/common/optional/hyprland.nix

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # for ozone-based and electron apps to run on wayland
    MOZ_ENABLE_WAYLAND = "1"; # for firefox to run on wayland
    MOZ_WEBRENDER = "1"; # for firefox to run on wayland
    XDG_SESSION_TYPE = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";

    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    _JAVA_AWT_WM_NONREPARENTING = "1"; # Fixing java apps (especially idea)

  };

  services.swayidle.timeouts = [
    {
      timeout = 600;
      command = "${config.wayland.windowManager.sway.package}/bin/swaymsg 'output * dpms off'";
      resumeCommand = "${config.wayland.windowManager.sway.package}/bin/swaymsg 'output * dpms on'";
    }
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    systemd = {
      enable = true;
      # TODO: experiment with whether this is required.
      # Same as default, but stop the graphical session too
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start sway-session.target"
      ];
      variables = [ "--all" ];
    };
    # workaround for nix-community/home-manager#5379
    checkConfig = false;

    extraSessionCommands = ''
      # for ozone-based and electron apps to run on wayland
      export NIXOS_OZONE_WL=1

      # for firefox to run on wayland
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_WEBRENDER=1

      export XDG_SESSION_TYPE=wayland
      export WLR_NO_HARDWARE_CURSORS=1
      export WLR_RENDERER_ALLOW_SOFTWARE=1
      # QT_QPA_PLATFORM,wayland
    '';
    config = {
      # Modifier (super key)
      modifier = "Mod4";

      # No sway bar
      bars = [ ];

      # defaultWorkspace = "workspace number 1";

      output =
        import ./monitors.nix {
          inherit lib;
          inherit (config) monitors;
        }
        // {
          "*" = {
            bg = "${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin.png fill";
          };
        };

      startup = [
        { command = "${pkgs.xorg.xhost}/bin/xhost si:localuser:root"; }
        { command = "${pkgs.autotiling-rs}/bin/autotiling-rs"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        {
          command = "${pkgs.import-gsettings}/bin/import-gsettings";
          always = true;
        }
        { command = "steam"; }
      ];

      gaps.inner = 5;
      gaps.outer = 15;
      window.border = 2;

      input = {
        #### Default settings by device type ####
        "type:pointer" = {
          accel_profile = "flat";
        };

        "type:keyboard" = {
          xkb_layout = "us";
          xkb_numlock = "enabled";
        };

        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          tap_button_map = "lrm";
          accel_profile = "adaptive";
        };

        #### Device specific settings ####

        "4152:5931:SteelSeries_SteelSeries_Rival_650_Wireless*" = {
          pointer_accel = "0.6";
        };
        # Razer Naga V2 Pro (bluetooth)
        "5426:169:Razer_Razer_Naga_V2_Pro*" = {
          pointer_accel = "0.6";
        };
        # Razer Naga V2 Pro (wireless)
        "5426:168:Razer_Razer_Naga_V2_Pro*" = {
          pointer_accel = "0.6";
        };
        # Razer Naga V2 Pro (wired)
        "5426:167:Razer_Razer_Naga_V2_Pro*" = {
          pointer_accel = "0.6";
        };

      };

      window = {
        titlebar = false;
        commands = [
          {
            criteria = {
              class = "^.*";
            };
            command = "inhibit_idle fullscreen";
          }

          {
            criteria = {
              app_id = "nm-connection-editor";
            };
            command = "floating enable";
          }
          {
            criteria = {
              app_id = "pwvucontrol";
            };
            command = "floating enable";
          }
          {
            criteria = {
              app_id = "blueman-manager";
            };
            command = "floating enable";
          }
          {
            criteria = {
              class = "steam";
              title = "Friends List";
            };
            command = "floating enable";
          }
          {
            criteria = {
              title = "^Syncthing Tray( \(.*\))?$";
            };
            command = "floating enable";
          }
        ];
      };

      assigns = {
        "4:4" = [
          { class = "steam"; }
          { class = "gamescope"; }
          { class = "heroic"; }
        ];
        "11:F1" = [ { title = ".*Discord"; } ];
      };

      #windowrule = [
      # Dialogs
      #  "float, title:^(Open File)(.*)$"
      #  "float, title:^(Select a File)(.*)$"
      #  "float, title:^(Choose wallpaper)(.*)$"
      #  "float, title:^(Open Folder)(.*)$"
      #  "float, title:^(Save As)(.*)$"
      #  "float, title:^(Library)(.*)$"
      #  "float, title:^(Accounts)(.*)$"
      #];

      #windowrulev2 = [
      # Steam
      #  "center, title:(Steam), class:(), floating:1"
      #  "float, title:(Steam Settings), class:(steam)"
      #  "float, title:(Friends List), class:(steam)"

      # Polkit
      #"dimaround, class:(polkit-gnome-authentication-agent-1)"
      #  "center,    class:(polkit-gnome-authentication-agent-1)"
      #  "float,     class:(polkit-gnome-authentication-agent-1)"
      #  "pin,       class:(polkit-gnome-authentication-agent-1)"

      # Disable borders on floating windows
      #  "noborder, floating:1"

      # Inhibit idle whenever an application is fullscreened
      #  "idleinhibit always, fullscreen:1"
      #];

      colors = {
        focused = {
          background = "$base";
          text = "$text";
          border = "$blue";
          indicator = "$sapphire";
          childBorder = "$blue";
        };
        focusedInactive = {
          background = "$base";
          text = "$text";
          border = "$surface2";
          indicator = "$overlay1";
          childBorder = "$surface2";
        };
        unfocused = {
          background = "$base";
          text = "$text";
          border = "$surface1";
          indicator = "$overlay0";
          childBorder = "$surface1";

        };
        urgent = {
          background = "$base";
          text = "$red";
          border = "$red";
          indicator = "$red";
          childBorder = "$red";

        };
      };

      fonts = {
        names = [ "Roboto" ];
        style = "Regular";
      };
    };
    extraConfig = ''
      workspace number 1
      blur enable
      corner_radius 7
    '';
  };

  # # TODO: move below into individual .nix files with their own configs
  # home.packages = builtins.attrValues {
  #   inherit (pkgs)
  #   nm-applet --indicator &  # notification manager applet.
  #   bar
  #   waybar  # closest thing to polybar available
  #   where is polybar? not supported yet: https://github.com/polybar/polybar/issues/414
  #   eww # alternative - complex at first but can do cool shit apparently
  #
  #   # Wallpaper daemon
  #   hyprpaper
  #   swaybg
  #   wpaperd
  #   mpvpaper
  #   swww # vimjoyer recoomended
  #   nitrogen
  #
  #   # app launcher
  #   rofi-wayland;
  #   wofi # gtk rofi
  # };
}
