{ config, pkgs, ... }: {
  services.swayidle = {
    package = pkgs.swayidle;
    enable = true;
    extraArgs = [ "idlehint 600" ];
    systemdTarget = "graphical-session.target";
    timeouts = [
      {
        timeout = 300;
        command = "${config.programs.swaylock.package}/bin/swaylock -f";
      }
      {
        timeout = 600;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
    events = [
      { event = "before-sleep"; command = "${config.programs.swaylock.package}/bin/swaylock -f -c 000000"; }
    ];
  };
}
