{ config, configVars, ... }:
{
  services = {
    blueman-applet.enable = true;
    gammastep = {
      enable = true;
      provider = "manual";
      latitude = 47.61;
      longitude = -122.27;
      tray = true;
    };
    network-manager-applet.enable = true;
  };
}
