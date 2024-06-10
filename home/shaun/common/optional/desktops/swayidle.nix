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
    ];
    events = [
      { event = "before-sleep"; command = "${config.programs.swaylock.package}/bin/swaylock -f -c 000000"; }
    ];
  };
}
