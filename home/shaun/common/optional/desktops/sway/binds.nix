{
  lib,
  pkgs,
  config,
  ...
}:
let
  workspaces = lib.mergeAttrsList (map (m: m.workspaces) config.monitors);

  # Map keys (arrows and hjkl) to hyprland directions (l, r, u, d)
  directions = rec {
    left = "left";
    right = "right";
    up = "up";
    down = "down";
    h = left;
    l = right;
    k = up;
    j = down;
  };

  modifier = config.wayland.windowManager.sway.config.modifier;

  wpctl = lib.getExe' pkgs.wireplumber "wpctl"; # installed via /hosts/common/optional/audio.nix

  brightnessctl = lib.getExe pkgs.brightnessctl;
  handlr = lib.getExe pkgs.handlr;
  swaylock = lib.getExe pkgs.swaylock;
  playerctl = lib.getExe pkgs.playerctl;
  rofi = lib.getExe config.programs.rofi.package;
  grimshot = lib.getExe pkgs.sway-contrib.grimshot;

  defaultApp = type: "${handlr} launch ${type}";

  terminal = config.home.sessionVariables.TERM;
  editor-cli = config.home.sessionVariables.EDITOR;
  browser = defaultApp "x-scheme-handler/https";
  editor = defaultApp "text/plain";
  file-manager = defaultApp "inode/directory";
in
{
  wayland.windowManager.sway.config = {
    keybindings = {
      # FIXME(workarounds): remove when mangohud 0.8.0 is released
      "Super_R" = "exec mangohudctl toggle no_display";

      #################### Program Launch ####################
      "${modifier}+Return" = "exec ${terminal}";
      "${modifier}+b" = "exec ${browser}";
      "${modifier}+e" = "exec ${terminal} ${editor-cli}";
      "${modifier}+shift+e" = "exec ${editor}";
      "${modifier}+f" = "exec ${file-manager}";
      "${modifier}+d" = "exec ${rofi} -modi \"run,drun\" -show drun";
      "${modifier}+p" = "exec ${rofi} -modi \"display:${pkgs.rofi-randr}/bin/rofi-randr\" -show display";

      #################### Basic Bindings ####################
      "${modifier}+q" = "kill";
      "${modifier}+ctrl+shift+e" = "exit";
      "${modifier}+ctrl+shift+l" =
        "exec ${swaylock} -f -i ${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin-blurred.png";
      "alt+return" = "fullscreen";

      # Function Keys
      "XF86AudioLowerVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      "XF86AudioRaiseVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+";
      "XF86MonBrightnessDown" = "exec ${brightnessctl} -q set 5%-";
      "XF86MonBrightnessUp" = "exec ${brightnessctl} -q set +5%";
      "XF86TouchpadToggle" = "input type:touchpad events toggle enabled disabled";
      "XF86AudioPlay" = "exec ${playerctl} play-pause";
      "XF86AudioNext" = "exec ${playerctl}  next";
      "XF86AudioPrev" = "exec ${playerctl} previous";
      "XF86AudioMute" = "exec ${wpctl} set-mute @DEFAULT_SINK@ toggle";
      # Screenshots
      "Alt+Print" = "exec ${grimshot} --notify savecopy output";
      "Ctrl+Print" = "exec ${grimshot} --notify savecopy window";
      "Ctrl+Shift+Print" = "exec ${grimshot} --notify  savecopy area";
      "Print" = "exec ${grimshot} --notify  savecopy anything";

      # Layouts
      "${modifier}+s" = "layout stacking";
      "${modifier}+t" = "layout tabbed";

      # Modes
      "${modifier}+End" = "mode passthrough";
    }
    # Change workspace
    // builtins.listToAttrs (
      lib.mapAttrsToList (index: name: {
        name = "${modifier}+${name}";
        value = "workspace ${
          lib.strings.concatStrings [
            index
            ":"
            name
          ]
        }";
      }) workspaces
    )
    # Move window to workspace
    // builtins.listToAttrs (
      lib.mapAttrsToList (index: name: {
        name = "${modifier}+shift+${name}";
        value = " move container to workspace ${
           lib.strings.concatStrings [
             index
             ":"
             name
           ]
         }";
      }) workspaces
    )
    # Move focus
    // builtins.listToAttrs (
      lib.mapAttrsToList (key: direction: {
        name = "${modifier}+${key}";
        value = "focus ${direction}";
      }) directions
    )
    # move window / group
    // builtins.listToAttrs (
      lib.mapAttrsToList (key: direction: {
        name = "${modifier}+shift+${key}";
        value = "move ${direction}";
      }) directions
    )
    # Move monitor focus
    // builtins.listToAttrs (
      lib.mapAttrsToList (key: direction: {
        name = "${modifier}+alt+${key}";
        value = "focus output ${direction}";
      }) directions
    )
    # Move workspace to other monitor
    // builtins.listToAttrs (
      lib.mapAttrsToList (key: direction: {
        name = "${modifier}+alt+shift+${key}";
        value = "move workspace output ${direction}";
      }) directions
    );
    modes = {
      passthrough = {
        "${modifier}+Home" = "mode default";
      };
    };
  };
}
