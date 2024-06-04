{ pkgs, config, lib, ... }: {
  imports = [
    # custom key binds
    ./binds.nix
    ../hyprpaper.nix

    ########## Utilities ##########
    ../services/swaync.nix # Notification daemon
    ../services/wl-paste.nix # Clipboard functionality
    ../waybar.nix # infobar
    ../swayidle.nix
    ../swaylock.nix
    ../rofi.nix
    ../tray.nix

  ];

  # NOTE: xdg portal package is currently set in /hosts/common/optional/hyprland.nix

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    systemd = {
      enable = true;
      # TODO: experiment with whether this is required.
      # Same as default, but stop the graphical session too
      #extraCommands = lib.mkBefore [
      #  "systemctl --user stop graphical-session.target"
      #  "systemctl --user start sway-session.target"
      #];
      #variables = [ "--all" ];
    };

    extraSessionCommands = [
      "export NIXOS_OZONE_WL=1" # for ozone-based and electron apps to run on wayland
      "export MOZ_ENABLE_WAYLAND=1" # for firefox to run on wayland
      "export MOZ_WEBRENDER=1" # for firefox to run on wayland
      "export XDG_SESSION_TYPE=wayland"
      "export WLR_NO_HARDWARE_CURSORS=1"
      "export WLR_RENDERER_ALLOW_SOFTWARE=1"
      "export XCURSOR_SIZE=24"
      # QT_QPA_PLATFORM,wayland
    ];

    config = {
      # Modifier (super key)
      modifier = "Mod4";

      # No sway bar
      bars = [ ];

      defaultWorkspace = "workspace 1:1";

      output = import ./monitors.nix
        {
          inherit lib;
          inherit (config) monitors;
        } // {
        "*" = {
          bg = "${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin.png fill";
        };
      };

      startup = [
        { command = "${pkgs.xorg.xhost}/bin/xhost si:localuser:root"; }
        { command = "${pkgs.autotiling-rs}/bin/autotiling-rs"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        { command = "${pkgs.import-gsettings}/bin/import-gsettings"; }
        { command = "${pkgs.steam}/bin/steam"; }
        #{ command = "${pkgs.discord}/bin/discord"; }
      ];

      gaps.inner = 5;
      gaps.outer = 20;
      window.border = 2;

      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_numlock = "enabled";
        };
        "type:pointer" = {
          accel_profile = "flat";
        };
        "4152:5931:SteelSeries_SteelSeries_Rival_650_Wireless*" = {
          pointer_accel = "0.6";
        };
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          tap_button_map = "lrm";
          accel_profile = "adaptive";
        };
      };

      window = {
        titlebar = false;
        commands = [
          { command = "inhibit_idle fullscreen"; criteria = { class = "^.*"; }; }
        ];
      };

      assigns = {
        "4:4" = [
          { class = "steam"; }
          { class = "heroic"; }
        ];
        "11:F1" = [
          { title = ".*Discord"; }
        ];
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
