{ pkgs, ... }: {
  programs.sway = {
    enable = true;
    package = null;
  };
  xdg.portal = {
    #    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      xdg-desktop-portal-xapp
    ];
  };

  # less delay on failed login
  security.pam.services.swaylock = {
    nodelay = true;
    failDelay = {
      enable = true;
      delay = 500000;
    };
  };

}
