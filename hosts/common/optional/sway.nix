{
  pkgs,
  lib,
  ...
}:
{
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
  };
  xdg.portal = {
    #    wlr.enable = true;
    extraPortals = builtins.attrValues {
      inherit (pkgs)
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
        xdg-desktop-portal-xapp
        ;
    };
  };

  services.xserver = {
    xkb.extraLayouts.real-prog-dvorak = {
      description = "Real Programmer's Dvorak";
      languages = [ "eng" ];
      symbolsFile = lib.custom.relativeToRoot "pkgs/common/symbols/real-prog-dvorak";
    };
  };

  services.logind = {
    powerKey = "ignore";
    lidSwitchDocked = "suspend";
  };

  # less delay on failed login
  # security.pam.services.swaylock = {
  #   nodelay = true;
  #   failDelay = {
  #     enable = true;
  #     delay = 500000;
  #   };
  # };

}
