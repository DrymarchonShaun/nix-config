{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = builtins.attrValues {
      inherit (pkgs)
        roboto
        roboto-mono
        roboto-slab
        liberation_ttf
        ;
      nerdfonts = pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; };
    };

    fontconfig = {
      defaultFonts = {
        serif = [
          "Roboto Slab"
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
