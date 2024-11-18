{
  lib,
  fetchFromGitHub,
  clangStdenv,
  cmake,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "FAE_Linux";
  version = "v1.3";

  src = fetchFromGitHub {
    owner = "UnlegitSenpaii";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-lm/s9rc4/2TIT2mzIPwdFoPB9GZm4qluK2yVoL7KwnE=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -Dm755 out/bin/FAE_Linux $out/bin/FAE_Linux
  '';

  meta = {
    description = "Factorio Achievement Enabler for Linux";
    homepage = "https://github.com/UnlegitSenpaii/FAE_Linux/";
    maintainers = [ lib.maintainers.DrymarchonShaun ];
  };
})
