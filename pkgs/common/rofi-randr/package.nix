{
  rustPlatform,
  fetchFromGitHub,
  xorg,
  makeWrapper,
  pkg-config,
}:
rustPlatform.buildRustPackage {
  pname = "rofi-randr";
  version = "0-unstable-09-08-2025";

  src = fetchFromGitHub {
    owner = "Rintse";
    repo = "rofi-randr";
    rev = "ac92836b843b45c8897fffd4fcd1140959b1775d";
    hash = "sha256-Aa905bkX6ygc35NoTY7yZPJXEmY1gufaW3JOdnGLpz8=";
  };

  buildInputs = [
    xorg.libXrandr
    xorg.libX11
  ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  cargoHash = "sha256-FE+xz2Xe71YskqDwkFpry+uhgrKeYYVqkWAYK3gKlIQ=";

  meta = {
    mainProgram = "rofi-randr";
  };
}
