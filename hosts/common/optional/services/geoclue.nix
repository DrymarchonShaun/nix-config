{
  lib,
  config,
  configVars,
  ...
}:
{
  location.provider = lib.mkDefault "geoclue2";
  services.geoclue2 = {
    enable = lib.mkDefault true;
  };
}
