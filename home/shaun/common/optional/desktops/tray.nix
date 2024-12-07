{ config, ... }:
{
  services = {
    blueman-applet.enable = true;
    gammastep = {
      enable = true;
      provider = "manual";
      latitude = config.hostSpec.latitude;
      longitude = config.hostSpec.longitude;
      tray = true;
    };
    network-manager-applet.enable = true;
  };
}
