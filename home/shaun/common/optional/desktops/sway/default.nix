{
  pkgs,
  osConfig,
  config,
  lib,
  ...
}:
{
  imports = [
    # custom key binds
    ./binds.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar.nix

    ########## Utilities ##########
    ../common/gtk.nix
    ../common/qt.nix
    ../common/services/clipboard.nix
    ../common/services/wlsunset.nix
    ../common/services/playerctl.nix
    # ../common/services/swaync.nix
    ../common/services/tray.nix
  ];

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

  wayland.windowManager.sway = {
    enable = true;
    package = null;
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

    config = {
      # Modifier (super key)
      modifier = "Mod4";

      # No sway bar
      bars = [ ];

      output = {
        "*" = {
          bg = "${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin.png fill";
        };
      }
      // (builtins.listToAttrs (
        map (
          m:
          let
            scaleAdjustedx = m.x / m.scale;
            scaleAdjustedy = m.y / m.scale;
          in
          {
            name = m.name;
            value = (
              if m.enabled then
                {
                  mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}Hz";
                  scale = toString m.scale;
                  pos = "${toString scaleAdjustedx} ${toString scaleAdjustedy}";
                }
              else
                "disable"
            );
          }
        ) osConfig.monitors
      ));

      workspaceOutputAssign = lib.flatten (
        map (
          m:
          lib.mapAttrsToList (workspace: key: {
            output = m.name;
            workspace = "${workspace}:${key}";
          }) m.workspaces
        ) osConfig.monitors
      );

      startup = [
        { command = "${lib.getExe pkgs.xorg.xhost} si:localuser:root"; }
        { command = "${pkgs.autotiling-rs}/bin/autotiling-rs"; }
        { command = "${lib.getExe pkgs.hyprpolkitagent}"; }
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
          xkb_layout = "us,real-prog-dvorak";
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
              class = "steam";
              title = "Recordings & Screenshots";
            };
            command = "floating enable";
          }
          {
            criteria = {
              class = "steam_app_107410";
            };
            command = "shortcuts_inhibitor enable";
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
        names = [ "Inter:medium" ];
        # style = "Regular";
      };
    };
    extraConfig = ''
      workspace number 1
      blur enable
      corner_radius 7
    '';
  };
}
