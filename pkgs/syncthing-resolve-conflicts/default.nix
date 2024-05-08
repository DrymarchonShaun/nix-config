{ lib
, writeShellScriptBin
, fetchFromGitHub
}:

writeShellScriptBin "syncthing-resolve-conflicts" (builtins.readFile "${fetchFromGitHub {
  owner = "dschrempf";
  repo = "syncthing-resolve-conflicts";
  rev = "36264c6af098938f1ea26fabe1e89d60510aa963";
  hash = "sha256-g7oWUU2JWYsXXRIq5Be+ELQENkPkSJ1e5ZAO35sa9g4=";
}}/syncthing-resolve-conflicts")
