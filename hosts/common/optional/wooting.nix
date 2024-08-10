{ pkgs, ... }:
{
  hardware.wooting.enable = true;
  environment.systemPackages = [ pkgs.wootility ];
}
