{ lib
, fetchFromGitHub
, clangStdenv
, cmake
,
}:

clangStdenv.mkDerivation
  (finalAttrs: {
    pname = "FAE_Linux";
    version = "v1.1";

    src = fetchFromGitHub {
      owner = "UnlegitSenpaii";
      repo = finalAttrs.pname;
      rev = finalAttrs.version;
      hash = "sha256-H8OSkh6MvD6BA01YoyMH3ZMgxbDpXLyM2dFZz232gtc=";
    };

    nativeBuildInputs = [
      cmake
    ];

    installPhase = ''
      install -Dm755 /build/source/out/bin/FAE_Linux $out/bin/FAE_Linux
    '';

    meta = {
      description = "Factorio Achievement Enabler for Linux";
      homepage = "https://github.com/UnlegitSenpaii/FAE_Linux/";
      maintainers = with lib.maintainers;
        [ DrymarchonShaun ];
    };
  })
