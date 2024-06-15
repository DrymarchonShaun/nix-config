{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.discord-patched-launcher ];
  systemd.user.services.discord = {
    Unit = {
      StartLimitBurst = 30;
      Description =
        "Autostart Discord in Sway";
      Requires = [ "tray.target" ];
      After = [ "graphical-session-pre.target" "tray.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      RestartSec = 5;
      Restart = "on-failure";
      # ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      # ExecStart = "${pkgs.discord-patched-launcher}/bin/discord";
      ExecStart = lib.mkForce (pkgs.writeShellScript "discord-delayed" ''
        set -euo pipefail
        ${lib.getExe' pkgs.coreutils "sleep"} 3
        exec ${lib.getExe' pkgs.discord-patched-launcher "discord" }
      '');
      KillMode = "mixed";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
