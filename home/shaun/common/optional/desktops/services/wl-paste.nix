{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    xclip
    cliphist
  ];
  systemd.user.services.wl-clipboard = {
    Unit = {
      Description =
        "Autostart wl-clipboard";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
      KillMode = "mixed";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
