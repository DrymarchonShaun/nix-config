{ rustPlatform
, fetchFromGitHub
, libX11
, libXrandr
, makeWrapper
, pkg-config
}:
let
  version = "d9d2882da7f56c1fb5658b9fb10707620dc9fae3";
in
rustPlatform.buildRustPackage {
  pname = "rofi-randr";
  inherit version;

  src = fetchFromGitHub {
    owner = "Rintse";
    repo = "rofi-randr";
    rev = version;
    hash = "sha256-9PvuKLTnKYIFolUbnsohSXdPKh0QGDU0Xxirg8076Jc=";
  };

  buildInputs = [
    libXrandr
    libX11
  ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  #  postFixup = ''
  #    wrapProgram $out/bin/rofi-randr \
  #      --set DISPLAY_SERVER_OVERRIDE "xrandr_cli"
  #  '';

  cargoHash = "sha256-0Rw625yUlpKGOEV9USalbi4I/hfRfGa7QcNq0mi4KNQ=";
}
