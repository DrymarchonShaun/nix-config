{ pkgs, ... }:
{
  # mostly taken from https://github.com/jeffwkm/dotfiles/blob/main/modules/linux/fontconfig.nix
  fonts = {
    packages = builtins.attrValues {
      inherit (pkgs)
        inter
        jetbrains-mono
        noto-fonts
        ;
      nerdfonts = pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; };
    };
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      subpixel.rgba = "rgb";
      subpixel.lcdfilter = "default";
      defaultFonts = {
        serif = [
          "Inter:medium"
          "Inter"
          "Noto Sans"
        ];
        sansSerif = [
          "Inter:medium"
          "Inter"
          "Noto Sans"
        ];
        monospace = [
          "JetBrains Mono:medium"
          "JetBrains Mono"
          "Symbols Nerd Font Mono"
        ];
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match target="pattern">
            <test qual="any" name="family"><string>Noto Sans</string></test>
            <edit name="family" mode="prepend" binding="same"><string>Inter</string></edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family"><string>Roboto</string></test>
            <edit name="family" mode="prepend" binding="same"><string>Inter</string></edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family"><string>Segoe UI</string></test>
            <edit name="family" mode="prepend" binding="same"><string>Inter</string></edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family"><string>arial</string></test>
            <edit name="family" mode="prepend" binding="same"><string>Inter</string></edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family"><string>Helvetica Neue</string></test>
            <edit name="family" mode="prepend" binding="same"><string>Inter</string></edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family"><string>Helvetica</string></test>
            <edit name="family" mode="prepend" binding="same"><string>Inter</string></edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family"><string>Liberation Sans</string></test>
            <edit name="family" mode="prepend" binding="same"><string>Inter</string></edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family"><string>ui-monospace</string></test>
            <edit name="family" mode="prepend" binding="same"><string>JetBrains Mono</string></edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family"><string>SFMono-Regular</string></test>
            <edit name="family" mode="prepend" binding="same"><string>JetBrains Mono</string></edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family"><string>SF Mono</string></test>
            <edit name="family" mode="prepend" binding="same"><string>JetBrains Mono</string></edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family"><string>SF Mono</string></test>
            <edit name="family" mode="prepend" binding="same"><string>JetBrains Mono</string></edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family"><string>Menlo</string></test>
            <edit name="family" mode="prepend" binding="same"><string>JetBrains Mono</string></edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family"><string>Consolas</string></test>
            <edit name="family" mode="prepend" binding="same"><string>JetBrains Mono</string></edit>
          </match>
        </fontconfig>
      '';
    };
  };
}
