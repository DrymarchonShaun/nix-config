{ pkgs, ... }:
{
  hardware.wooting.enable = true;
  # use https://beta.wooting.io for the latest firmware instead
  # environment.systemPackages = [ pkgs.wootility ];
}
