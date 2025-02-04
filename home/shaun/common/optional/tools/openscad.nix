{ pkgs, ... }:
let
  gridfinity-rebuilt = pkgs.stdenv.mkDerivation {
    name = "gridfinity-rebuilt";
    version = "unstable";

    src = pkgs.fetchFromGitHub {
      owner = "kennetek";
      repo = "gridfinity-rebuilt-openscad";
      rev = "993814227204b942fc1c13e64a604427f835742a";
      hash = "sha256-QluKnfcMsFb1X67E0L2N+uK4DB+yjLwnksYiLMYp22Q=";
    };

    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r $src $out/gridfinity-rebuilt
    '';
  };
in
{
  home.packages = with pkgs; [
    openscad-unstable
  ];

  home.sessionVariables = {
    OPENSCADPATH = "${gridfinity-rebuilt}";
  };
}
