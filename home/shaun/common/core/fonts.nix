{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.noto-fonts
    pkgs.roboto
    pkgs.roboto-mono
    (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    pkgs.meslo-lgs-nf
  ];

}
