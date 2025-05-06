{
  stdenv,
  fetchzip,
  steam-run,
}:
stdenv.mkDerivation rec {
  pname = "hemtt";
  version = "1.15.1";

  src = fetchzip {
    url = "https://github.com/BrettMayson/HEMTT/releases/download/v1.15.1/linux-x64.zip";
    hash = "sha256-LOAFPAwo0FgfUO3Q3+XAQqF0hSfoRtJjaVbXoIUy2aM=";
  };

  buildInputs = [ steam-run ];

  installPhase = ''
    mkdir -p $out/bin
    cp hemtt $out/bin/
    chmod +x $out/bin/hemtt
  '';
}

# {
#   rust-bin,
#   makeRustPlatform,
#   fetchFromGitHub,
#   pkg-config,
#   openssl,
# }:
# let
#   rustPlatform = makeRustPlatform {
#     cargo = rust-bin.stable.latest.minimal;
#     rustc = rust-bin.stable.latest.minimal;
#   };
# in
# rustPlatform.buildRustPackage rec {
#   pname = "hemtt";
#   version = "1.15.1";
#
#   src = fetchFromGitHub {
#     owner = "BrettMayson";
#     repo = "HEMTT";
#     rev = "v${version}";
#     hash = "sha256-eOPCQiln6Z/EAcNqO5+7RfvSevV0DzMAD02uTz3VoPY=";
#   };
#   nativeBuildInputs = [
#     pkg-config
#     openssl.dev
#   ];
#
#   PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
#
#   cargoHash = "sha256-pA38wekIK58DB427N/rDPCIe66gKT00GesDxXwMAeX0=";
# }
