{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.syncthing.tray;
in
{
  home.packages = [ pkgs.syncthing-resolve-conflicts ];
  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      command = "syncthingtray --wait";
      package = pkgs.syncthingtray;
    };
  };

  systemd.user.services.${cfg.package.pname} = {
    Unit = {
      StartLimitBurst = 30;
    };

    Service = {
      RestartSec = 5;
      # Make it look like ${cfg.package} starts immediately, but actually delay it for a few seconds.
      # We need to make systemd think it already started, so that sway can finish starting
      # `graphical-session.target`, after which it starts `xdg-desktop-portal.service`. Once the
      # desktop portal is started, waybar can finally finish initializing the tray, and at that
      # point syncthingtray can start without crashing.
      ExecStart = lib.mkForce (
        pkgs.writeShellScript "${cfg.package.pname}-delayed" ''
          set -euo pipefail
          ${lib.getExe' pkgs.coreutils "sleep"} 3
          exec ${lib.getExe' cfg.package cfg.command}
        ''
      );

      Restart = "on-failure";
      KillMode = "mixed";
    };
  };
}
