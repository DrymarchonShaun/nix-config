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
    hash = "sha256-+bw1n8O9YlXc4ulXk8lRvcZ/SLrBTwVPRwOsANlJWGE=";
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
