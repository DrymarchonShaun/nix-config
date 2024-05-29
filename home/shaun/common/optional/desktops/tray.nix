{ ... }:
{
  services = {
    blueman-applet.enable = true;
    gammastep = {
      enable = true;
      provider = "geoclue2";
      tray = true;
    };
    network-manager-applet.enable = true;
  };
}
