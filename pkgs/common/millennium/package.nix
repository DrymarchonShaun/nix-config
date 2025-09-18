{
  fetchFromGitHub,
  callPackage,
  pkgsi686Linux,
  cmake,
  ninja,
  lib,

}:
let
  version' = "2.29.1";

  src' = fetchFromGitHub {
    owner = "SteamClientHomebrew";
    repo = "Millennium";
    tag = "v${version'}";
    hash = "sha256-e1H198VSa1tZo9kpEk8qJ+9b9jdvLjzZ11QPFoV1+E4=";
    fetchSubmodules = true;
  };

  shims = callPackage ./shims.nix { inherit version' src'; };
  assets = callPackage ./assets.nix { inherit version' src'; };
  venv = pkgsi686Linux.python311.withPackages (
    py:
    (with py; [
      setuptools
      pip

      arrow
      psutil
      requests
      gitpython
      cssutils
      websockets
      watchdog
      pysocks
      pyperclip
      semver
    ])
    ++ [
      (callPackage ./python/millennium.nix { inherit version' src'; })
      (callPackage ./python/millennium-core-utils.nix { inherit version' src'; })
    ]
  );
in
pkgsi686Linux.stdenv.mkDerivation {
  pname = "millennium";
  version = version';

  src = src';

  buildInputs = [
    shims
    assets
    pkgsi686Linux.python311
    (pkgsi686Linux.openssl.override {
      static = true;
    })
    (
      (pkgsi686Linux.curl.override {
        http2Support = false;
        gssSupport = false;
        zlibSupport = true;
        opensslSupport = true;
        brotliSupport = false;
        zstdSupport = false;
        http3Support = false;
        scpSupport = false;
        pslSupport = false;
        idnSupport = false;
      }).overrideAttrs
      (old: {
        configureFlags = (old.configureFlags or [ ]) ++ [
          "--enable-static"
          "--disable-shared"
        ];
        propagatedBuildInputs = [
          (pkgsi686Linux.openssl.override {
            static = true;
          }).out
        ];
      })
    )
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  env = {
    NIX_OS = 1;
    inherit venv assets shims;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/millennium
    cp libmillennium_x86.so $out/lib/millennium

    runHook postInstall
  '';

  NIX_CFLAGS_COMPILE = [
    "-isystem ${pkgsi686Linux.python311}/include/${pkgsi686Linux.python311.libPrefix}"
  ];

  NIX_LDFLAGS = [ "-l${pkgsi686Linux.python311.libPrefix}" ];

  meta = {
    maintainers = with lib.maintainers; [ DrymarchonShaun ];
  };
}
