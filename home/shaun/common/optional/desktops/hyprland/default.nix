{ pkgs, config, lib, ... }: {
  imports = [
    # custom key binds
    ./binds.nix
  ];

  # NOTE: xdg portal package is currently set in /hosts/common/optional/hyprland.nix

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      # TODO: experiment with whether this is required.
      # Same as default, but stop the graphical session too
      variables = [ "--all" ];
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
    extraConfig = ''
        device:elan0412:00-04f3:3240-touchpad {
        accel_profile=adaptive
      }
    '';
    # plugins = [];

    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors/

      monitor = map
        (m:
          let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
          in
          "${m.name},${if m.enabled then "${resolution},${position},1" else "disable"}"
        )
        config.monitors;

      workspace = [
        "1,monitor:eDP-1,default=true"
        "2,monitor:eDP-1"
        "3,monitor:eDP-1"
        "4,monitor:eDP-1"
        "5,monitor:HDMI-A-1,default=true"
        "5,monitor:DP-1,default=true"
      ];


      env = [
        "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
        "MOZ_WEBRENDER, 1" # for firefox to run on wayland
        "XDG_SESSION_TYPE,wayland"
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
        # "QT_QPA_PLATFORM,wayland"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        # cursor_inactive_timeout = 4;
      };

      input = {
        kb_layout = "us";
        follow_mouse = true;
        accel_profile = "flat";
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        touchpad = {
          disable_while_typing = true;
          natural_scroll = true;
        };
      };

      decoration = {
        active_opacity = 0.94;
        inactive_opacity = 0.75;
        fullscreen_opacity = 1.0;
        rounding = 3;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
        };
        drop_shadow = true;
        shadow_range = 12;
        shadow_offset = "3 3";
        "col.shadow" = "0x44000000";
        "col.shadow_inactive" = "0x66000000";
      };

      animations = {
        enabled = true;
        bezier = [
          "easein,0.11, 0, 0.5, 0"
          "easeinback,0.36, 0, 0.66, -0.56"
          "easeout,0.5, 1, 0.89, 1"
          "easeoutback,0.34, 1.56, 0.64, 1"
        ];

        animation = [
          "border,1,3,easeout"
          "fadeDim,1,3,easeout"
          "fadeIn,1,3,easeout"
          "fadeOut,1,3,easein"
          "fadeShadow,1,3,easeout"
          "fadeSwitch,1,3,easeout"
          "windowsIn,1,3,easeoutback,slide"
          "windowsMove,1,3,easeoutback"
          "windowsOut,1,3,easeinback,slide"
          "workspaces,1,2,easeoutback,slide"
        ];
      };
    };
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
