{ lib, stdenv }:

stdenv.mkDerivation {
  name = "wallpapers";
  src = ./.;

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/share/backgrounds
    cp -pr ./*.png $out/share/backgrounds
  '';

  meta = {
    description = "My Wallpapers";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ DrymarchonShaun ];
  };
}
