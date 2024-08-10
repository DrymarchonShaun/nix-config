{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      roboto
      roboto-mono
      liberation_ttf
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "Liberation Serif"
          "Symbols Nerd Font Mono"
        ];
        sansSerif = [
          "Roboto"
          "Symbols Nerd Font Mono"
        ];
        monospace = [
          "Roboto Mono"
          "Symbols Nerd Font Mono"
        ];
      };
    };
  };
}
