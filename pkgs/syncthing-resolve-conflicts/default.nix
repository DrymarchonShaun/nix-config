{ lib
, writeShellScriptBin
, fetchurl
,
}:

writeShellScriptBin "syncthing-resolve-conflicts" (
  builtins.readFile (builtins.fetchurl {
    url = "https://raw.githubusercontent.com/dschrempf/syncthing-resolve-conflicts/master/syncthing-resolve-conflicts";
    sha256 = "sha256:1y3c1c4i57v4i38y2bcrxyi4a4gyaf1v3df0530q47jjpkr5jdmw";
  })
)
