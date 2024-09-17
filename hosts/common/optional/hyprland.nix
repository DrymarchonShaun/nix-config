{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland; # default
  };

  services.logind = {
    powerKey = "ignore";
    lidSwitchDocked = "suspend";
    extraConfig = ''
      IdleAction=suspend
      IdleActionSec=5min
    '';
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
