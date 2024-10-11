{ pkgs, ... }:
{
  home.packages = [
    pkgs.unstable.wineWowPackages.stagingFull
    pkgs.winetricks
  ];
}
