{ config, configVars, ... }:
{
  services = {
    blueman-applet.enable = true;
    gammastep = {
      enable = true;
      provider = "manual";
      latitude = configVars.latitude;
      longitude = configVars.longitude;
      tray = true;
    };
    network-manager-applet.enable = true;
  };
}
