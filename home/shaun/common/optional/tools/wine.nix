{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.wineWowPackages.stagingFull
    winetricks
  ];
}
