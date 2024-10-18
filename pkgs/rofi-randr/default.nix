{
  rustPlatform,
  fetchFromGitHub,
  libX11,
  libXrandr,
  makeWrapper,
  pkg-config,
}:
rustPlatform.buildRustPackage {
  pname = "rofi-randr";
  version = "0-unstable-07-07-2024";

  src = fetchFromGitHub {
    owner = "Rintse";
    repo = "rofi-randr";
    rev = "f7d1290833ff93bda1ff9ecfd05a67f00589850e";
    hash = "sha256-KqHbS5hneLgx37A493fcZbxhlkrxd6hdwlDp31bEwak=";
  };

  buildInputs = [
    libXrandr
    libX11
  ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  cargoHash = "sha256-jkTv/no/EmbyQkFHc091VrOnCMoE/uAtsVUxBGkxMNk=";
}
