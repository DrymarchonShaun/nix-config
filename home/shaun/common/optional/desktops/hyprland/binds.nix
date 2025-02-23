#NOTE: Actions prepended with `hy3;` are specific to the hy3 hyprland plugin
{
  config,
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    settings = {
      # Reference of supported bind flags: https://wiki.hyprland.org/Configuring/Binds/#bind-flags

      #
      # ========== Mouse Binds ==========
      #
      bindm = [
        # hold alt + leftlclick  to move/drag active window
        "SUPER,mouse:272,movewindow"
        # hold alt + rightclick to resize active window
        "SUPER,mouse:273,resizewindow"
      ];
      #
      # ========== Non-consuming Binds ==========
      #
      bindn = [
        # allow tab selection using mouse
        ", mouse:272, hy3:focustab, mouse"
      ];
      #
      # ========== Repeat Binds ==========
      #
      binde =
        let
          pamixer = lib.getExe pkgs.pamixer; # installed via /hosts/common/optional/audio.nix
          brightnessctl = lib.getExe pkgs.brightnessctl;
        in
        [
          # Resize active window 5 pixels in direction
          "Control_L&Shift_L&Alt_L, h, resizeactive, -5 0"
          "Control_L&Shift_L&Alt_L, j, resizeactive, 0 5"
          "Control_L&Shift_L&Alt_L, k, resizeactive, 0 -5"
          "Control_L&Shift_L&Alt_L, l, resizeactive, 5 0"

          #FIXME: repeat is not working for these
          # Volume
          ",XF86AudioLowerVolume,exec,${pamixer} -d 5"
          ",XF86AudioRaiseVolume,exec,${pamixer} -i 5"
          # Display Brightness
          ",XF86MonBrightnessDown,exec,${brightnessctl} -q set 5%-"
          ",XF86MonBrightnessUp,exec,${brightnessctl} -q set +5%"
        ];
      #
      # ========== One-shot Binds ==========
      #
      bind =
        let
          workspaces = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "0";
            "11" = "F1";
            "12" = "F2";
            "13" = "F3";
            "14" = "F4";
            "15" = "F5";
            "16" = "F6";
            "17" = "F7";
            "18" = "F8";
            "19" = "F9";
            "20" = "F10";
            "21" = "F11";
            "22" = "F12";
          };
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
          pamixer = lib.getExe pkgs.pamixer; # installed via /hosts/common/optional/audio.nix
          handlr = lib.getExe pkgs.handlr;
          playerctl = lib.getExe pkgs.playerctl;
          rofi = lib.getExe config.programs.rofi.package;
          grimblast = lib.getExe pkgs.grimblast;

          defaultApp = type: "${handlr} launch ${type}";

          terminal = config.home.sessionVariables.TERM;
          editor-cli = config.home.sessionVariables.EDITOR;
          editor = defaultApp "text/plain";
          browser = defaultApp "x-scheme-handler/https";
          file-manager = defaultApp "inode/directory";
        in
        lib.flatten [

          #
          # ========== Quick Launch ==========
          #
          "SUPER,d,exec,${rofi}  -modi \"run,drun\" -show drun"
          "SUPER_SHIFT,space,exec,rofi  -modi \"run,drun\" -show run"
          "SUPER,p,exec,${rofi} -modi \"display:${lib.getExe pkgs.rofi-randr}\" -show display"

          "SUPER,Return,exec,${terminal}"
          "SUPER,e,exec,${terminal} -e ${editor-cli}"
          "SUPER_SHIFT,e,exec,${editor}"
          "SUPER,f,exec,${file-manager}"
          "SUPER,b,exec,${browser}"

          #
          # ========== Screenshotting ==========
          #
          # TODO check on status of flameshot and multimonitor wayland. as of Oct 2024, it's a clusterfuck
          # so resorting to grimblast in the meantime
          #"CTRL_ALT,p,exec,flameshot gui"
          ",Print,exec,${grimblast} --notify --freeze copysave active"
          "ALT,Print,exec,${grimblast} --notify --freeze copysave output"
          "CTRL,Print,exec,${grimblast} --notify --freeze copysave area"

          #
          # ========== Media Controls ==========
          #
          # see "binde" above for volume ctrls that need repeat binding
          # Output
          ", XF86AudioMute, exec, ${pamixer} --toggle-mute"
          # Player
          ", XF86AudioPlay, exec, '${playerctl} play-pause'"
          ", XF86AudioNext, exec, '${playerctl} next'"
          ", XF86AudioPrev, exec, '${playerctl} previous'"

          #
          # ========== Windows and Groups ==========
          #
          #NOTE: window resizing is under "Repeat Binds" above

          # Close the focused/active window
          "SUPER,q,hy3:killactive"
          "SUPER,q,killactive"

          # Fullscreen
          #"ALT,f,fullscreen,0" # 0 - fullscreen (takes your entire screen), 1 - maximize (keeps gaps and bar(s))
          "ALT,return,fullscreenstate,2 -1" # `internal client`, where `internal` and `client` can be -1 - current, 0 - none, 1 - maximize, 2 - fullscreen, 3 - maximize and fullscreen
          # Float
          "SUPER,space,togglefloating"
          # Pin Active Floatting window
          "SUPER_SHIFT, p, pin, active" # pins a floating window (i.e. show it on all workspaces)

          # Splits groups
          "ALT,v,hy3:makegroup,v" # make a vertical split
          "SHIFTALT,v,hy3:makegroup,h" # make a horizontal split
          "ALT,x,hy3:changegroup,opposite" # toggle btwn splits if untabbed
          "ALT,s,togglesplit"

          # Tab groups
          "ALT,g,hy3:changegroup,toggletab" # tab or untab the group
          #"ALT,t,lockactivegroup,toggle"
          "ALT,apostrophe,changegroupactive,f"
          "SHIFTALT,apostrophe,changegroupactive,b"

          #
          # ========== Workspaces ==========
          #
          # Change workspace
          (lib.mapAttrsToList (id: key: "SUPER,${key},workspace,${id}") workspaces)

          # Special/scratch
          "SUPER,y, togglespecialworkspace"
          "SHIFTSUPER,y,movetoworkspace,special"

          # Move window to workspace
          (lib.mapAttrsToList (id: key: "SHIFTSUPER,${key},hy3:movetoworkspace,${id}") workspaces)

          # Move focus from active window to window in specified direction
          #(lib.mapAttrsToList (key: direction: "ALT,${key}, exec, customMoveFocus ${direction}") directions)
          (lib.mapAttrsToList (key: direction: "SUPER,${key},hy3:movefocus,${direction},warp") directions)

          # Move windows
          #(lib.mapAttrsToList (key: direction: "SHIFTALT,${key}, exec, customMoveWindow ${direction}") directions)
          (lib.mapAttrsToList (key: direction: "SHIFTSUPER,${key},hy3:movewindow,${direction}") directions)

          # Move workspace to monitor in specified direction
          # (lib.mapAttrsToList (
          #   key: direction: "CTRLSHIFT,${key},movecurrentworkspacetomonitor,${direction}"
          # ) directions)

          #
          # ========== Misc ==========
          #
          "SHIFTALT,r,exec,hyprctl reload" # reload the configuration file
          "SUPERSHIFT,l,exec,hyprlock" # lock the wm
          "SUPERCTRLSHIFT,e,exec,wlogout" # lock the wm
        ];
    };
    extraConfig = ''
      submap=shortcuts-inhibited
      bind=ALT,return,fullscreenstate,2 -1
      bindm="SUPER,mouse:272,movewindow"
      submap=reset
    '';
  };
}
