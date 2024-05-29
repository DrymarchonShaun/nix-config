{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage {
  pname = "swaync-catppuccin";
  version = "main";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "swaync";
    rev = "main";
    hash = "sha256-kwK03esY/4L8DVkuFyw8vRjg2SsKCQ3xh7md+l0rPCc=";
  };

  npmDepsHash = "sha256-BWKyHf6ocZXMCUV15Au2In5ozsofIs3rrWhqWvJESKQ=";

  npmBuildScript = "build";
  installPhase = ''
    mkdir -p $out
    cp -r dist/* $out/
  '';


  meta = {
    description = "";
    homepage = "";
    maintainers = with lib.maintainers;
      [ drymarchonshaun ];
  };
}
