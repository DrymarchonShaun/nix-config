#NOTE: Actions prepended with `hy3;` are specific to the hy3 hyprland plugin
{
  config,
  lib,
  pkgs,
  ...
}:
/*
  NOTE: Binds in the let in block are used in the default config, and the "shortcuts-inhibited" submap.
  Binds that prove to be problematic in certain games or applications get moved to the regular hyprland.settings = {};
*/

let
  workspaces = lib.mergeAttrsList (map (m: m.workspaces) config.monitors);

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
  wpctl = lib.getExe' pkgs.wireplumber "wpctl"; # installed via /hosts/common/optional/audio.nix
  handlr = lib.getExe pkgs.handlr;
  playerctl = lib.getExe pkgs.playerctl;
  rofi = lib.getExe config.programs.rofi.package;
  grimblast = lib.getExe pkgs.grimblast;
  brightnessctl = lib.getExe pkgs.brightnessctl;

  defaultApp = type: "${handlr} launch ${type}";

  terminal = config.home.sessionVariables.TERM;
  editor-cli = config.home.sessionVariables.EDITOR;
  editor = defaultApp "text/plain";
  browser = defaultApp "x-scheme-handler/https";
  file-manager = defaultApp "inode/directory";
  #
  # ========== Mouse Binds ==========
  #
  bindm = [ ];
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
  binde = [
    # Resize active window 5 pixels in direction
    "Control_L&Shift_L&Alt_L, h, resizeactive, -5 0"
    "Control_L&Shift_L&Alt_L, j, resizeactive, 0 5"
    "Control_L&Shift_L&Alt_L, k, resizeactive, 0 -5"
    "Control_L&Shift_L&Alt_L, l, resizeactive, 5 0"

    #FIXME: repeat is not working for these
    # Volume
    ",XF86AudioLowerVolume,exec,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ",XF86AudioRaiseVolume,exec,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    # Display Brightness
    ",XF86MonBrightnessDown,exec,${brightnessctl} -q set 5%-"
    ",XF86MonBrightnessUp,exec,${brightnessctl} -q set +5%"
  ];
  #
  # ========== One-shot Binds ==========
  #
  bind = lib.flatten [
    # Quick Launch
    "SUPER,p,exec,${rofi} -modi \"display:${lib.getExe pkgs.rofi-randr}\" -show display"

    "SUPER,Return,exec,${terminal}"
    "SUPER,e,exec,${terminal} -e ${editor-cli}"
    "SUPER_SHIFT,e,exec,${editor}"
    "SUPER,f,exec,${file-manager}"
    "SUPER,b,exec,${browser}"

    #  Screenshotting
    ",Print,exec,${grimblast} --notify --freeze copysave active $XDG_SCREENSHOTS_DIR/$(date +%Y%m%d-%H%M%S).png"
    "ALT,Print,exec,${grimblast} --notify --freeze copysave output $XDG_SCREENSHOTS_DIR/$(date +%Y%m%d-%H%M%S).png"
    "CTRL,Print,exec,${grimblast} --notify --freeze copysave area $XDG_SCREENSHOTS_DIR/$(date +%Y%m%d-%H%M%S).png"

    # Media Controls
    # see "binde" above for volume ctrls that need repeat binding
    ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_SINK@ toggle"

    ", XF86AudioPlay, exec, ${playerctl} play-pause"
    ", XF86AudioNext, exec, ${playerctl} next"
    ", XF86AudioPrev, exec, ${playerctl} previous"

    #  Windows and Groups

    # Fullscreen
    "ALT,return,fullscreenstate,2 -1" # `internal client`, where `internal` and `client` can be -1 - current, 0 - none, 1 - maximize, 2 - fullscreen, 3 - maximize and fullscreen
    "SUPER,space,togglefloating"
    "SUPER_SHIFT, p, pin, active" # pins a floating window (i.e. show it on all workspaces)

    # Splits groups
    "ALT,v,hy3:makegroup,v" # make a vertical split
    "SHIFTALT,v,hy3:makegroup,h" # make a horizontal split
    "ALT,x,hy3:changegroup,opposite" # toggle btwn splits if untabbed

    # Tab groups
    "ALT,g,hy3:changegroup,toggletab" # tab or untab the group
    "ALT,apostrophe,changegroupactive,f"
    "SHIFTALT,apostrophe,changegroupactive,b"

    # Workspaces

    # Change workspace
    (lib.mapAttrsToList (id: key: "SUPER,${key},workspace,${id}") workspaces)

    # Special/scratch
    "SUPER,y, togglespecialworkspace"
    "SHIFTSUPER,y,movetoworkspace,special"

    # Move window to workspace
    (lib.mapAttrsToList (id: key: "SHIFTSUPER,${key},hy3:movetoworkspace,${id}") workspaces)

    # Move focus from active window to window in specified direction
    (lib.mapAttrsToList (key: direction: "SUPER,${key},hy3:movefocus,${direction},warp") directions)

    # Move windows
    (lib.mapAttrsToList (key: direction: "SHIFTSUPER,${key},hy3:movewindow,${direction}") directions)

    #  Misc
    "SHIFTALT,r,exec,hyprctl reload" # reload the configuration file
    "SUPERSHIFT,l,exec,pidof hyprlock || hyprlock" # lock the wm
    "SUPERCTRLSHIFT,e,exec,wlogout" # lock the wm
    # FIXME(workarounds): remove when mangohud 0.8.0 is released
    "SUPER_R,,exec,mangohudctl toggle no_display"
  ];
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bindm = lib.flatten [
        bindm
        [
          # hold alt + leftlclick  to move/drag active window
          "SUPER,mouse:272,movewindow"
          # hold alt + rightclick to resize active window
          "SUPER,mouse:273,resizewindow"
        ]
      ];
      bindn = lib.flatten [
        bindn
        [
        ]
      ];
      binde = lib.flatten [
        binde
        [

        ]
      ];

      bind = lib.flatten [
        bind
        [
          # Close the focused/active window
          "SUPER,q,hy3:killactive"
          "SUPER,q,killactive"

          # Quick Launch
          "SUPER,d,exec,${rofi}  -modi \"run,drun\" -show drun"
          "SUPER_SHIFT,space,exec,rofi  -modi \"run,drun\" -show run"
        ]
      ];
    };
    extraConfig = ''
      submap=shortcuts-inhibited
      ${lib.concatStringsSep "\n" (map (b: "bind=${b}") bind)}
      ${lib.concatStringsSep "\n" (map (b: "binde=${b}") binde)}
      ${lib.concatStringsSep "\n" (map (b: "bindm=${b}") bindm)}
      ${lib.concatStringsSep "\n" (map (b: "bindn=${b}") bindn)}
      submap=reset
    '';
  };
}
