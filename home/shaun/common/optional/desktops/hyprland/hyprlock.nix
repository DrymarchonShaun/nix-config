{ lib, ... }:
{
  catppuccin.hyprlock.enable = true;
  programs.hyprlock = {
    enable = true;
    importantPrefixes = [
      "$"
      "monitor"
      "size"
      "source"
    ];
    settings = {
      general = {
        # disable_loading_bar = true;
        grace = 5; # grace period in seconds that the lock will unlock on mouse movement.
        # hide_cursor = true;
        # no_fade_in = false;
      };

      background = lib.mkDefault [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
    };
  };
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };
      listener = [
        {
          timeout = 800;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1000;
          on-timeout = "hyprctl dispatch dpms off";
          # on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
