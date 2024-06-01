{ lib, pkgs, config, ... }:
let
  modifier = config.wayland.windowManager.sway.config.modifier;
  pamixer = "${pkgs.pamixer}/bin/pamixer";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  swaylock = "${config.programs.swaylock.package}/bin/swaylock";
  playerctl = "${config.services.playerctld.package}/bin/playerctl";
  grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";


  gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
  xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
  defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

  terminal = config.home.sessionVariables.TERM;
  browser = defaultApp "x-scheme-handler/https";
  editor = defaultApp "text/plain";
  file-manager = defaultApp "inode/directory";
  launcher = "${config.programs.rofi.package}/bin/rofi";
in
{
  wayland.windowManager.sway.config = {
    keybindings = {
      #################### Program Launch ####################
      "${modifier}+Return" = "exec ${terminal}";
      "${modifier}+b" = "exec ${browser}";
      "${modifier}+e" = "exec ${editor}";
      "${modifier}+f" = "exec ${file-manager}";
      "${modifier}+d" = "exec ${launcher} -modi \"run,drun\" -show drun";
      "${modifier}+p" = "exec ${launcher} -modi \"display:${pkgs.rofi-randr}/bin/rofi-randr\" -show display";

      #################### Basic Bindings ####################
      "${modifier}+q" = "kill";
      "${modifier}+shift+e" = "exit";
      "${modifier}+l" = "exec ${swaylock} -f -i ${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin-blurred.png";
      "alt+return" = "fullscreen";

      # Function Keys
      "XF86AudioLowerVolume" = "exec ${pamixer} -d 5";
      "XF86AudioRaiseVolume" = "exec ${pamixer} -i 5";
      "XF86MonBrightnessDown" = "exec ${brightnessctl} -q set 5%-";
      "XF86MonBrightnessUp" = "exec ${brightnessctl} -q set +5%";
      "XF86TouchpadToggle" = "input type:touchpad events toggle enabled disabled";
      "XF86AudioPlay" = "exec ${playerctl} play-pause";
      "XF86AudioNext" = "exec ${playerctl}  next";
      "XF86AudioPrev" = "exec ${playerctl} previous";

      # Screenshots
      "Print" = "exec ${grimshot} --notify copy window";
      "Alt+Print" = "exec ${grimshot} --notify  copy output";
      "Ctrl+Print" = "exec ${grimshot} --notify  copy area";

    };
  };
}
