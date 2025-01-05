{ pkgs, lib, ... }:
let
  gridfinity-rebuilt = pkgs.stdenv.mkDerivation {
    name = "gridfinity-rebuilt";
    version = "unstable";

    src = pkgs.fetchFromGitHub {
      owner = "kennetek";
      repo = "gridfinity-rebuilt-openscad";
      rev = "e1e5dcc49e8ffb5f8d718059830b4313d52f2ed7";
      sha256 = "sha256-CqWq43CAS4PSfttJfyKUbh9To6OC3wkO4Cg6GY2LcDo=";
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
