{ rustPlatform
, fetchFromGitHub
, libX11
, libXrandr
, makeWrapper
, pkg-config
}:

rustPlatform.buildRustPackage {
  pname = "rofi-randr";
  version = "git";

  buildInputs = [
    libXrandr
    libX11
  ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  src = fetchFromGitHub {
    owner = "Rintse";
    repo = "rofi-randr";
    rev = "c64ac0fc963b9de19aba2feac8f317e0618819f4";
    hash = "sha256-RtLUtSw3wsicxmZtA+b4h05clNgk3KSYslGMC1zX7kQ=";
  };

  #  postFixup = ''
  #    wrapProgram $out/bin/rofi-randr \
  #      --set DISPLAY_SERVER_OVERRIDE "xrandr_cli"
  #  '';

  cargoHash = "sha256-CrWjeHB0JKGH/ncGy/v+GxSs/xmO9JAuH5wXxUllbTQ=";
}
