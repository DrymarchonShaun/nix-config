{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      wl-clipboard
      wl-clip-persist
      xclip
      ;
  };

  services.copyq = {
    enable = true;
  };

  systemd.user.services.wl-clip-persist = {
    Unit = {
      description = "Keep Wayland clipboard even after programs close";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";
    };
  };
}
