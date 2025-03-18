{ config, ... }:
{
  services.wlsunset = {
    enable = true;
    longitude = config.hostSpec.longitude;
    latitude = config.hostSpec.latitude;
    temperature = {
      day = 5500;
      night = 3700;
    };
  };
}
