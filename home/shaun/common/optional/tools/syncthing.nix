{ configLib, config, pkgs, ... }:
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
  # config = configLib.mkDelayedUnit pkgs config.services.syncthing.tray.package "/bin/syncthingtry --wait";
  systemd.user.services.syncthingtray = {
    Unit = {
      StartLimitBurst = 30;
    };

    Service = {
      RestartSec = 5;
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      ExecStart = "${config.services.syncthing.tray.package}/bin/syncthingtray --wait";
      Restart = "on-failure";
      KillMode = "mixed";
    };
  };
}
