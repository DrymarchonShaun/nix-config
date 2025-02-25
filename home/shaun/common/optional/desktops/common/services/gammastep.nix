{ config, ... }:
{
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = config.hostSpec.latitude;
    longitude = config.hostSpec.longitude;
  };
}
