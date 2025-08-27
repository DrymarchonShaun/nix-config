{
  lib,
  fetchFromGitHub,
  clangStdenv,
  cmake,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "FAE_Linux";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "UnlegitSenpaii";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-NfK2XkgEIMpIIxlFftH/0dFQ7e8+d1gLYb1d1NeMTP8=";
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
