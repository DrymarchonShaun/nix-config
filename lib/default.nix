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

  easyeffects = {

    getPresets =
      path:
      lib.map
        (file: {
          name = lib.removeSuffix ".json" file;
          value = builtins.fromJSON (builtins.readFile "${path}/${file}");
        })
        (
          builtins.attrNames (
            lib.filterAttrs (file: type: lib.hasSuffix ".json" file && type == "regular") (
              builtins.readDir path
            )
          )
        );

    profileAutoload =
      {
        type,
        device,
        name,
        profile,
        preset,
      }:
      {
        xdg.configFile."easyeffects/autoload/${type}/${device}:${profile}.json" = {
          text = builtins.toJSON {
            device = device;
            device-description = name;
            device-profile = profile;
            preset-name = preset;
          };
        };
      };

  };
}
