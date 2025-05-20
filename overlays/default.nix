#
# This file defines overlays/custom modifications to upstream packages
#

{ inputs, ... }:

let

  master = import inputs.nixpkgs-master { overlays = [ ]; };

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

    # vencord = master.vencord.overrideAttrs (oldAttrs: rec {
    #   src =
    #     if (oldAttrs.version == "1.12.1") then
    #       prev.fetchFromGitHub {
    #         owner = "Vendicated";
    #         repo = "Vencord";
    #         rev = "v1.12.2";
    #         hash = "sha256-a4lbeuXEHDMDko8wte7jUdJ0yUcjfq3UPQAuSiz1UQU=";
    #       }
    #     else
    #       throw "remove the override stupid";
    # });

    waybar = final.unstable.waybar.overrideAttrs (oldAttrs: rec {
      patches = oldAttrs.patches or [ ] ++ [
        ./3934.patch
      ];
    });

    steam = prev.steam.override { privateTmp = false; };

    # arma3-unix-launcher = prev.arma3-unix-launcher.overrideAttrs (oldAttrs: rec {
    #   patches = oldAttrs.patches or [ ] ++ [
    #     (prev.fetchpatch {
    #       url = "https://patch-diff.githubusercontent.com/raw/muttleyxd/arma3-unix-launcher/pull/291.patch";
    #       hash = "sha256-fBwWfu4IR02zJuiCGhkAKzMlkJEHw/+whw3potR++fA=";
    #     })
    #   ];
    # });
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
