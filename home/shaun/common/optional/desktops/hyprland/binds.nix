{ lib, pkgs, config, ... }:
{
  wayland.windowManager.hyprland.settings = {
    bindm = [
      "SUPER,mouse:272,movewindow"
      "SUPER,mouse:273,resizewindow"
    ];


    binde =
      let
        pamixer = "${pkgs.pamixer}/bin/pamixer";
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      in
      [
        ",XF86AudioLowerVolume,exec,${pamixer} -d 5"
        ",XF86AudioRaiseVolume,exec,${pamixer} -i 5"
        ",XF86MonBrightnessDown,exec,${brightnessctl} -q set 5%-"
        ",XF86MonBrightnessUp,exec,${brightnessctl} -q set +5%"
      ];

    bind =
      let
        workspaces = [
          "0"
          "1"
          "2"
          "3"
          "4"
          "5"
          "6"
          "7"
          "8"
          "9"
          "F1"
          "F2"
          "F3"
          "F4"
          "F5"
          "F6"
          "F7"
          "F8"
          "F9"
          "F10"
          "F11"
          "F12"
        ];
        # Map keys (arrows and hjkl) to hyprland directions (l, r, u, d)
        directions = rec {
          left = "l";
          right = "r";
          up = "u";
          down = "d";
          h = left;
          l = right;
          k = up;
          j = down;
        };


        swaylock = "${config.programs.swaylock.package}/bin/swaylock";
        #playerctl = "${config.services.playerctld.package}/bin/playerctl";
        #playerctld = "${config.services.playerctld.package}/bin/playerctld";
        #makoctl = "${config.services.mako.package}/bin/makoctl";
        #wofi = "${config.programs.wofi.package}/bin/wofi";
        #pass-wofi = "${pkgs.pass-wofi.override {
        #pass = config.programs.password-store.package;
        #}}/bin/pass-wofi";

        #grimblast = "${pkgs.inputs.hyprwm-contrib.grimblast}/bin/grimblast";
        pactl = "${pkgs.pulseaudio}/bin/pactl";
        #tly = "${pkgs.tly}/bin/tly";
        #gtk-play = "${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play";
        #notify-send = "${pkgs.libnotify}/bin/notify-send";

        gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
        xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
        defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

        terminal = config.home.sessionVariables.TERM;
        browser = defaultApp "x-scheme-handler/https";
        editor = defaultApp "text/plain";
        file-manager = defaultApp "inode/directory";
        launcher = "${config.programs.rofi.package}/bin/rofi";
      in
      [
        #################### Program Launch ####################
        "SUPER,Return,exec,${terminal}"
        "SUPER,b,exec,${browser}"
        "SUPER,e,exec,${editor}"
        "SUPER,f,exec,${file-manager}"
        "SUPER,D,exec,${launcher} -modi \"run,drun\" -show drun"
        "SUPER,P,exec,${launcher} -modi \"display:${pkgs.rofi-randr}/bin/rofi-randr\" -show display"

        #################### Basic Bindings ####################
        "SUPER,q,killactive"
        "SUPERSHIFT,e,exit"

        "SUPER,s,togglesplit"
        "ALT,Return,fullscreen,1"
        "SHIFTALT,Return,fullscreen,0"
        "SUPERSHIFT,space,togglefloating"

        "SUPER,minus,splitratio,-0.25"
        "SUPERSHIFT,minus,splitratio,-0.3333333"

        "SUPER,equal,splitratio,0.25"
        "SUPERSHIFT,equal,splitratio,0.3333333"

        "SUPER,g,togglegroup"
        "SUPER,t,lockactivegroup,toggle"
        "SUPER,apostrophe,changegroupactive,f"
        "SUPERSHIFT,apostrophe,changegroupactive,b"

        "SUPER,u,togglespecialworkspace"
        "SUPERSHIFT,u,movetoworkspacesilent,special"
        "SUPER,l,exec,${swaylock} -f -i ${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin.png"

        # Function Keys
        ",XF86AudioMute,exec,${pactl} set-sink-mute @DEFAULT_SINK@ toggle"

      ] ++
      # Change workspace
      (map
        (n:
          "SUPER,${n},workspace,name:${n}"
        )
        workspaces) ++
      # Move window to workspace
      (map
        (n:
          "SHIFTSUPER,${n},movetoworkspacesilent,name:${n}"
        )
        workspaces) ++
      # Move focus
      (lib.mapAttrsToList
        (key: direction:
          "SUPER,${key},movefocus,${direction}"
        )
        directions) ++
      # Swap windows
      (lib.mapAttrsToList
        (key: direction:
          "ALTSHIFT,${key},swapwindow,${direction}"
        )
        directions) ++
      # Move windows
      (lib.mapAttrsToList
        (key: direction:
          "SHIFTSUPER,${key},movewindoworgroup,${direction}"
        )
        directions) ++
      # Move monitor focus
      (lib.mapAttrsToList
        (key: direction:
          "SUPERALT,${key},focusmonitor,${direction}"
        )
        directions) ++
      # Move workspace to other monitor
      (lib.mapAttrsToList
        (key: direction:
          "SUPERALTSHIFT,${key},movecurrentworkspacetomonitor,${direction}"
        )
        directions);
  };
}
