{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.qpwgraph ];
  systemd.user.services.qpwgraph = {
    Unit = {
      StartLimitBurst = 30;
      Description =
        "Autostart qpwgraph in Sway";
      Requires = [ "tray.target" ];
      After = [ "graphical-session-pre.target" "tray.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      RestartSec = 5;
      Restart = "on-failure";
      ExecStart = lib.mkForce (pkgs.writeShellScript "qpwgraph-delayed" ''
        set -euo pipefail
        ${lib.getExe' pkgs.coreutils "sleep"} 3
        exec ${lib.getExe' pkgs.qpwgraph "qpwgraph" } -m
      '');
      KillMode = "mixed";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
