{ pkgs, ... }:
{
  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      package = pkgs.syncthingtray;
    };
  };
  systemd.user.services.syncthingtray = {
    Unit = {
      StartLimitBurst = 30;
    };

    Service = {
      RestartSec = 5;
      Restart = "on-failure";
      KillMode = "mixed";
    };
  };
}
