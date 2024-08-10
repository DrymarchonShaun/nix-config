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
    ../hyprpaper.nix

    ########## Utilities ##########
    ../services/swaync.nix # Notification daemon
    ../services/wl-paste.nix # Clipboard functionality
    ../waybar.nix # infobar
    ../monitors.nix
    ../swayidle.nix
    ../swaylock.nix
    ../rofi.nix
    ../tray.nix
    ../wayland.nix # various wayland utilities

  ];

  # NOTE: xdg portal package is currently set in /hosts/common/optional/hyprland.nix

  services.swayidle.timeouts = [
    {
      timeout = 600;
      command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
      resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
    }
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      # TODO: experiment with whether this is required.
      # Same as default, but stop the graphical session too
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
      variables = [ "--all" ];
    };
    extraConfig = ''
        device:elan0412:00-04f3:3240-touchpad {
        accel_profile=adaptive
      }
    '';
    # plugins = [];

    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors/

      monitor = map (
        m:
        let
          resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
          position = "${toString (m.x / m.scale)}x${toString (m.y / m.scale)}";
          scale = "${toString m.scale}";
        in
        "${m.name},${if m.enabled then "${resolution},${position},${scale}" else "disable"}"
      ) config.monitors;

      exec-once = [
        "${pkgs.hyprpaper}/bin/hyprpaper"
        #"${pkgs.waybar}/bin/waybar"
        "${pkgs.xorg.xhost}/bin/xhost si:localuser:root"
      ];

      env = [
        "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
        "MOZ_WEBRENDER, 1" # for firefox to run on wayland
        "XDG_SESSION_TYPE,wayland"
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
        "XCURSOR_SIZE,24"
        # "QT_QPA_PLATFORM,wayland"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        # cursor_inactive_timeout = 4;
      };

      misc = {
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = true;
        mouse_refocus = false;
        accel_profile = "flat";
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        touchpad = {
          disable_while_typing = true;
          natural_scroll = true;
        };
      };

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
        # Steam
        "center, title:(Steam), class:(), floating:1"
        "float, title:(Steam Settings), class:(steam)"
        "float, title:(Friends List), class:(steam)"

        # Polkit
        #"dimaround, class:(polkit-gnome-authentication-agent-1)"
        "center,    class:(polkit-gnome-authentication-agent-1)"
        "float,     class:(polkit-gnome-authentication-agent-1)"
        "pin,       class:(polkit-gnome-authentication-agent-1)"

        # Disable borders on floating windows
        "noborder, floating:1"

        # Inhibit idle whenever an application is fullscreened
        "idleinhibit always, fullscreen:1"
      ];

      decoration = {
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
        shadow_range = 4;
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
