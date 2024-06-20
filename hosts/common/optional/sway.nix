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

}
