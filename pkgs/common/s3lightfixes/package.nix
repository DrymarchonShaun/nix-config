{
  rust-bin,
  makeRustPlatform,
  fetchFromGitHub,
}:
let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.stable.latest.minimal;
    rustc = rust-bin.stable.latest.minimal;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "s3lightfixes";
  version = "0.3.29";

  src = fetchFromGitHub {
    owner = "magicaldave";
    repo = "S3LightFixes";
    rev = "v${version}";
    sha256 = "sha256-dpvDfv29DWz7sSk7ZP2wdTiYKEfSmHB8HWqV6EK6qxs=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-3K/rTYykbWD1/4w8KoY//8m4ld9NSBFdoSLNkH6NxHs=";

}
