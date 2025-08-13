{ pkgs, ... }:
{
  services.lact = {
    enable = true;
    package = pkgs.unstable.lact;
  };
}
