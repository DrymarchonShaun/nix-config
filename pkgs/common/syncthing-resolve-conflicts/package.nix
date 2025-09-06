{
  writeShellScriptBin,
  fetchurl,
}:

writeShellScriptBin "syncthing-resolve-conflicts" (
  builtins.readFile (fetchurl {
    url = "https://raw.githubusercontent.com/dschrempf/syncthing-resolve-conflicts/master/syncthing-resolve-conflicts";
    hash = "sha256-jUbnRKYmnJQodQ4d/anKcQG6NyXWqJGo821ZHyNzc5Q=";
  })
)
