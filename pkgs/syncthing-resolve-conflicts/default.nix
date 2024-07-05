{ lib
, writeShellScriptBin
, fetchurl
,
}:

writeShellScriptBin "syncthing-resolve-conflicts" (
  builtins.readFile (fetchurl {
    url = "https://raw.githubusercontent.com/dschrempf/syncthing-resolve-conflicts/master/syncthing-resolve-conflicts";
    sha256 = "sha256-vDZZ8rxSHoLBKMC1sYNT/hFFou+ZLeHRiGSfEgkLbPg=";
  })
)
