#
# This file defines overlays/custom modifications to upstream packages
#

{ inputs, ... }:

let

  master = import inputs.nixpkgs-master { overlays = [ ]; };
  unstable = import inputs.nixpkgs-unstable { overlays = [ ]; };

  # Adds my custom packages
  # FIXME: Add per-system packages
  additions =
    final: prev:
    (prev.lib.packagesFromDirectoryRecursive {
      callPackage = prev.lib.callPackageWith (final // { inherit inputs; });
      directory = ../pkgs/common;
    });

  linuxModifications = final: prev: prev.lib.mkIf final.stdenv.isLinux { };

  pythonModifications = final: prev: {
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (
        python-final: python-prev:
        let
          src = prev.fetchFromGitHub {
            owner = "openrazer";
            repo = "openrazer";
            rev = "refs/pull/2348/head";
            hash = "sha256-S7zNGihLJ2vfvGqm+ZbbxMB/FsY9XSVrtBvLeKNwHjc=";
          };
        in
        {
          openrazer = python-prev.openrazer.overridePythonAttrs (oldAttrs: {
            inherit src;
          });
          openrazer-daemon = python-prev.openrazer-daemon.overridePythonAttrs (oldAttrs: {
            inherit src;
          });
        }
      )
    ];
  };

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: let ... in {
    # ...
    # });

    hyprlandPlugins.hy3 = master.hyprlandPlugins.hy3;

    vencord = master.vencord;

    gamescope = unstable.gamescope;

    # TODO: remove once kernel 6.15.5 is in stable; ref: https://github.com/NixOS/nixpkgs/issues/421442
    ghostty = prev.ghostty.overrideAttrs (_: {
      preBuild = ''
        shopt -s globstar
        sed -i 's/^const xev = @import("xev");$/const xev = @import("xev").Epoll;/' **/*.zig
        shopt -u globstar
      '';
    });

    steam = prev.steam.override {
      privateTmp = false;
      extraPkgs =
        pkgs:
        (builtins.attrValues {
          inherit (pkgs.xorg)
            libXcursor
            libXi
            libXinerama
            libXScrnSaver
            ;

          inherit (pkgs.stdenv.cc.cc)
            lib
            ;

          inherit (pkgs)
            libpng
            libpulseaudio
            libvorbis
            libkrb5
            keyutils
            gperftools
            gamemode
            mangohud
            gamescope
            ;
        });
    };

    orca-slicer-overridden = prev.stdenv.mkDerivation {
      name = "orca-slicer-overridden";
      version = prev.orca-slicer.version;
      src = prev.orca-slicer;
      buildCommand = ''
        cp -r $src $out
        chmod -R u+w $out
        sed -i 's/gcode\;//' $out/share/applications/OrcaSlicer.desktop
      '';
    };
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
      #      overlays = [
      #     ];
    };
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
      #      overlays = [
      #     ];
    };
  };

  master-packages = final: _prev: {
    master = import inputs.nixpkgs-master {
      inherit (final) system;
      config.allowUnfree = true;
      #      overlays = [
      #     ];
    };
  };

  dev-packages = final: _prev: {
    dev = import inputs.nixpkgs-dev {
      inherit (final) system;
      config.allowUnfree = true;
      #      overlays = [
      #     ];
    };
  };

in
{
  default =
    final: prev:

    (additions final prev)
    // (modifications final prev)
    // (linuxModifications final prev)
    // (pythonModifications final prev)
    // (stable-packages final prev)
    // (unstable-packages final prev)
    // (master-packages final prev)
    // (dev-packages final prev);
}
