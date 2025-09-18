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
    # example = prev.example.overrideAttrs (previousAttrs: let ... in {
    # ...
    # });

    vencord = master.vencord;

    # gamescope = unstable.gamescope;

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
            git
            ;
        });
      extraProfile =
        let
          # millennium = inputs.millennium.packages.${final.system}.millennium;
          millennium = inputs.self.packages.${final.system}.millennium;
        in
        ''
          export LD_LIBRARY_PATH="${millennium}/lib/millenium/''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
          export LD_PRELOAD="${millennium}/lib/millennium/libmillennium_x86.so''${LD_PRELOAD:+:$LD_PRELOAD}"
        ''
        + (prev.steam.extraProfile or "");
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

    qemu_kvm = prev.qemu_kvm.overrideAttrs (attrs: {
      pipewireSupport = true;
      #patches = (attrs.patches or [ ]) ++ [ ./overlays/qemu-anti-detection.patch ];
    });

    OVMFFull = prev.OVMFFull.override {
      secureBoot = true;
      tpmSupport = true;
      # edk2 = pkgs.edk2.overrideAttrs (attrs: {
      #  patches = (attrs.patches or [ ]) ++ [ ./overlays/edk-to-am.patch ];
      # });
    };
  };

  stable-packages = final: prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
      overlays = [
      ];
    };
  };

  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
      overlays = [
        #        (unstable_final: unstable_prev: {
        #          mesa = unstable_prev.mesa.overrideAttrs (
        #            previousAttrs:
        #            let
        #              version = "25.1.2";
        #              hashes = {
        #                "25.1.5" = "sha256-AZAd1/wiz8d0lXpim9obp6/K7ySP12rGFe8jZrc9Gl0=";
        #                "25.1.4" = "sha256-DA6fE+Ns91z146KbGlQldqkJlvGAxhzNdcmdIO0lHK8=";
        #                "25.1.3" = "sha256-BFncfkbpjVYO+7hYh5Ui6RACLq7/m6b8eIJ5B5lhq5Y=";
        #                "25.1.2" = "sha256-oE1QZyCBFdWCFq5T+Unf0GYpvCssVNOEQtPQgPbatQQ=";
        #              };
        #            in
        #            rec {
        #              inherit version;
        #              src = prev.fetchFromGitLab {
        #                domain = "gitlab.freedesktop.org";
        #                owner = "mesa";
        #                repo = "mesa";
        #                rev = "mesa-${version}";
        #                sha256 = if hashes ? ${version} then hashes.${version} else "";
        #              };
        #            }
        #          );
        #        })
      ];
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
