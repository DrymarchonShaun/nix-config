{ pkgs, ... }:
{
  home.packages = [
    pkgs.wineWowPackages.stagingFull
    pkgs.winetricks
  ];
}
