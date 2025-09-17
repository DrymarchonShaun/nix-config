{
  fetchCrate,
  fetchFromGitHub,
  installShellFiles,
  lib,
  makeRustPlatform,
  openssl,
  pkg-config,
  replaceVars,
  rust-bin,
  stdenv,
  writeTextFile,
}:
let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.stable.latest.minimal;
    rustc = rust-bin.stable.latest.minimal;
  };

  arma3-wiki = stdenv.mkDerivation rec {
    name = "arma3-wiki";
    version = "0.4.1";

    dontBuild = true;

    src = fetchCrate {
      pname = "arma3-wiki";
      inherit version;
      hash = "sha256-RQuatoHILh/Bj6sARzr+KkFX14kiLPO0GSv3j4QxWtE=";
    };

    patches = [
      (replaceVars ./fetch-local-dist.patch {
        local_dist_repo = fetchFromGitHub {
          owner = "acemod";
          repo = "arma3-wiki";
          rev = "dist";
          hash = "sha256-lbx3B9WXbt0RDAJMkpssOm2Hm42LzYtYz1Iba5c1TKo=";
        };
      })
    ];

    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  };
in
rustPlatform.buildRustPackage rec {
  pname = "hemtt";
  version = "1.16.4";

  src = fetchFromGitHub {
    owner = "BrettMayson";
    repo = "HEMTT";
    rev = "v${version}";
    hash = "sha256-9M7ByKEPWVQ0uBEr5knmNUtUtVCzQdoic7lcfg/V9uk=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    openssl.dev
  ];

  HOME = "$TEMPDIR";
  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
  doCheck = false;

  cargoPatches = [
    (writeTextFile {
      name = "dep-local.patch";
      text = ''
        diff --git a/Cargo.toml b/Cargo.toml
        index d05155f7..3b2fff0b 100644
        --- a/Cargo.toml
        +++ b/Cargo.toml
        @@ -40,7 +40,7 @@ future_incompatible = "warn"
         nonstandard_style = "warn"

         [workspace.dependencies]
        -arma3-wiki = "${arma3-wiki.version}"
        +arma3-wiki = { path = "${arma3-wiki}" }
         automod =  "1.0.15"
         byteorder = "1.5.0"
         chumsky = "0.9.3"
      '';
    })
  ];

  cargoHash = "sha256-wz9QpfhMQnY2ElyOTzc0dVfZiGok8T9MDCLDRuoOj7w=";

  postInstall =
    ''''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      for bin in hemtt; do
        installShellCompletion --cmd $bin \
          --bash <($out/bin/$bin manage completions bash) \
          --fish <($out/bin/$bin manage completions fish) \
          --zsh <($out/bin/$bin manage completions zsh)
        done
    '';

}
