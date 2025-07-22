# FIXME(lib.custom): Add some stuff from hmajid2301/dotfiles/lib/module/default.nix, as simplifies option declaration
{ lib, ... }:
{
  # use path relative to the root of the project
  relativeToRoot = lib.path.append ../.;
  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (lib.strings.hasSuffix ".nix" path) # include .nix files
          )
        ) (builtins.readDir path)
      )
    );

  steam = {
    defaultOptions =
      {
        gamescope ? false,
        captureCursor ? false,
        preExtraEnvVars ? [ ],
        extraEnvVars ? [ ],
        preExtraPrefixCommand ? [ ],
        extraPrefixCommand ? [ ],
        extraGameOptions ? [ ],
      }:
      lib.concatStringsSep " " (
        lib.flatten [
          preExtraEnvVars
          (lib.optional gamescope "MANGOHUD=0")
          extraEnvVars
          preExtraPrefixCommand
          "gamemoderun"
          extraPrefixCommand
          (lib.optional gamescope "gamescope -W 2560 -H 1440 -r 165 -f --mangoapp ${(lib.optionalString captureCursor "--force-grab-cursor")} --")
          "%command%"
          extraGameOptions
        ]
      );
  };
}
