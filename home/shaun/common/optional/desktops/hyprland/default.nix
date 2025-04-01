{
  pkgs,
  config,
  lib,
  ...
}:
let
  # TODO(theming): do this better
  palette = lib.importJSON "${config.catppuccin.sources.palette}/palette.json";
in
{
  imports = [
    ./binds.nix
    ./hyprlock.nix
    ./hyprpanel.nix
    ./hyprpaper.nix
    ./wlogout.nix
    ../common/gtk.nix
    ../common/qt.nix
    ../common/services/clipboard.nix
    ../common/services/wlsunset.nix
    ../common/services/playerctl.nix
    # ../common/services/swaync.nix
    ../common/services/tray.nix
  ];

  catppuccin.hyprland = {
    enable = true;
    accent = "blue";
  };
  catppuccin.cursors.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ]; # fix for https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
      # TODO(hyprland): experiment with whether this is required.
      # Same as default, but stop the graphical session too
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };

    plugins = [
      pkgs.hyprlandPlugins.hy3
    ];

    settings = {
      #
      # ========== Environment Vars ==========
      #
      debug = {
        disable_logs = true;
      };

      env = [
        "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
        "MOZ_WEBRENDER, 1" # for firefox to run on wayland
        "XDG_SESSION_TYPE,wayland"
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "_JAVA_AWT_WM_NONREPARENTING,1" # Fixing java apps
      ];

      #
      # ========== Monitor ==========
      #
      # parse the monitor spec defined in nix-config/home/<user>/<host>.nix
      monitor = (
        map (
          m:
          let
            # if either width or height are 0, use highest supported resolution
            resolution =
              if (m.width == 0 || m.height == 0) then "highres" else "${toString m.width}x${toString m.height}";
            # if refresh rate isn't specified, use highest supported refresh rate
            refreshRate = if m.refreshRate == null then "highrr" else "${toString m.refreshRate}";
            # automatically calculate the proper position by dividing by the scale as described at https://wiki.hyprland.org/Configuring/Monitors/
            scaleAdjustedx = m.x / m.scale;
            scaleAdjustedy = m.y / m.scale;
          in
          "${m.name},${
            if m.enabled then
              lib.concatStringsSep "," [
                (lib.concatStrings [
                  resolution
                  "@"
                  refreshRate
                ])

                "${toString scaleAdjustedx}x${toString scaleAdjustedy}"

                "${toString m.scale}"

                "transform"
                "${toString m.transform}"

                "vrr"
                "${toString m.vrr}"
              ]
            else
              "disable"
          }"
        ) (config.monitors)
      );

      workspace = lib.flatten (
        map (
          m:
          lib.mapAttrsToList (
            workspace: key:
            if (workspace == 1 || workspace == "special") && m.primary == true then
              "${workspace}, monitor:${m.name}, defaultName:${key}, default:true, persistent:true"
            else
              "${workspace}, monitor:${m.name}, defaultName:${key}, default:false, persistent:true"
            # FIXME(monitors): need logic to set primary as default monitor for workspaces that don't match above conditions but because we're limited to 'map' it seems to add more complexity than it's worth
          ) m.workspaces
        ) config.monitors
      );

      #
      # ========== Behavior ==========
      #
      binds = {
        workspace_center_on = 1; # Whether switching workspaces should center the cursor on the workspace (0) or on the last active window for that workspace (1)
        movefocus_cycles_fullscreen = false; # If enabled, when on a fullscreen window, movefocus will cycle fullscreen, if not, it will move the focus in a direction.
      };
      input = {
        # kb_layout = "us,real-prog-dvorak";
        numlock_by_default = true;
        accel_profile = "flat";
        #sensitivity = -0.2;

        follow_mouse = 1;
        # follow_mouse options:
        # 0 - Cursor movement will not change focus.
        # 1 - Cursor movement will always change focus to the window under the cursor.
        # 2 - Cursor focus will be detached from keyboard focus. Clicking on a window will move keyboard focus to that window.
        # 3 - Cursor focus will be completely separate from keyboard focus. Clicking on a window will not change keyboard focus.
        mouse_refocus = false;

        touchpad = {
          tap-to-click = true;
          tap_button_map = "lrm";
          natural_scroll = true;
          disable_while_typing = true;
        };
      };

      device = [
        {
          name = "razer-razer-naga-v2-pro";
          # sensitivity = -0.2;
        }
        {
          name = "razer-razer-naga-v2-pro-mouse";
          # sensitivity = -0.2;
        }
        {
          name = "elan0412:00-04f3:3240-touchpad";
          accel_profile = "adaptive";
        }
      ];

      cursor.inactive_timeout = 10;
      misc = {
        disable_hyprland_logo = true;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        font_family = "Inter";
        #disable_autoreload = true;
        new_window_takes_over_fullscreen = 2; # 0 - behind, 1 - takes over, 2 - unfullscreen/unmaxize
        middle_click_paste = false;

        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      #
      # ========== Appearance ==========
      #
      #FIXME-rice colors conflict with stylix
      general = {
        gaps_in = 7;
        gaps_out = 7;
        "col.active_border" = lib.mkForce "rgb(${
          (builtins.replaceStrings [ "#" ] [ "" ] palette.macchiato.colors.blue.hex)
        })";
        border_size = 2;
        resize_on_border = true;
        hover_icon_on_border = true;
        allow_tearing = true; # used to reduce latency and/or jitter in games
      };
      decoration = {
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        rounding = 10;
        blur = {
          enabled = true;
          size = 4;
          passes = 2;
          new_optimizations = true;
          popups = true;
        };
        shadow = {
          enabled = true;
          range = 12;
          offset = "3 3";
        };
      };

      #
      # ========== Auto Launch ==========
      #
      # exec-once = ''${startupScript}/path'';
      # To determine path, run `which foo`
      exec-once = [
        ''${lib.getExe pkgs.xorg.xhost} si:localuser:root''
        ''${lib.getExe pkgs.hyprpolkitagent}''
        ''${lib.getExe pkgs.ipc-daemon}''
        # ''${pkgs.import-gsettings}/bin/import-gsettings''
        ''steam''
      ];
      #
      # ========== Layer Rules ==========
      #
      layer = [
        #"blur, rofi"
        #"ignorezero, rofi"
        #"ignorezero, logout_dialog"

      ];
      #
      # ========== Window Rules ==========
      #
      windowrule = [
        # Dialogs
        "float, title:^(Open File)(.*)$"
        "float, title:^(Select a File)(.*)$"
        "float, title:^(Choose wallpaper)(.*)$"
        "float, title:^(Open Folder)(.*)$"
        "float, title:^(Save As)(.*)$"
        "float, title:^(Library)(.*)$"
        "float, title:^(Accounts)(.*)$"
      ];
      windowrulev2 = [
        "float, class:^(galculator)$"
        "float, class:^(waypaper)$"
        "float, class:^(keymapp)$"

        #
        # ========== Always opaque ==========
        #
        "opaque, class:^([Gg]imp)$"
        "opaque, class:^([Ff]lameshot)$"
        "opaque, class:^([Ii]nkscape)$"
        "opaque, class:^([Bb]lender)$"
        "opaque, class:^([Oo][Bb][Ss])$"
        "opaque, class:^([Ss]team)$"
        "opaque, class:^([Ss]team_app_*)$"
        "opaque, class:^([Vv]lc)$"

        # Remove transparency from video
        "opaque, title:^(Netflix)(.*)$"
        "opaque, title:^(.*YouTube.*)$"
        "opaque, title:^(Picture-in-Picture)$"
        #
        # ========== Scratch rules ==========
        #
        #"size 80% 85%, workspace:^(special:special)$"
        #"center, workspace:^(special:special)$"

        #
        # ========== Steam rules ==========
        #
        # "stayfocused, title:^()$,class:^([Ss]team)$"
        "minsize 1 1, title:^()$,class:^([Ss]team)$"
        "monitor 0,   title:^()$,class:^([Ss]team)$"

        "workspace 6 silent, title:^([Ss]team)$,class:^([Ss]team)$"

        # catch all (for proton games?)
        "workspace 5, class:^([Ss]team_app_.*)$"
        # "monitor 0, class:^([Ss]team_app.*)$"

        # Stellaris
        "workspace 5, class:^([Pp]aradox [Ll]auncher)$"
        # "monitor 0, class:^([Pp]aradox [Ll]auncher)$"
        "workspace 5, title:^([Ss]tellaris)$"

        # TeamSpeak 3
        "workspace 11, title:^(TeamSpeak 3)$,class:^([Ss]team_proton)$"
        "monitor 1, title:^(TeamSpeak 3)$,class:^([Ss]team_proton)$"

        #
        # ========== Workspace Assignments ==========
        #
        "workspace 11 silent, class:^([Dd]iscord)$"
      ];

      # load at the end of the hyperland set
      # extraConfig = '''';

      #
      # ========== hy3 config ==========
      #
      #TODO enable this and config
      plugin = {
        hy3 = {
          autotile = {
            enable = true;
          };
        };
      };
      general.layout = "hy3";
    };
  };

}
