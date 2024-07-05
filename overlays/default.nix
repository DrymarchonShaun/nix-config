#
# This file defines overlays/custom modifications to upstream packages
#

{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://wiki.nixos.org/wiki/Overlays
  modifications = final: prev: {
    OVMFFull = prev.OVMFFull.override {
      secureBoot = true;
      tpmSupport = true;
      edk2 = prev.edk2.overrideAttrs (attrs: {
        patches = (attrs.patches or [ ]) ++ [ ./patches/edk2-to-am.patch ];
      });
    };
    qemu_kvm = prev.qemu_kvm.overrideAttrs (attrs: {
      pipewireSupport = true;
      patches = (attrs.patches or [ ]) ++ [ ./patches/qemu-anti-detection.patch ];
    });
    cinnamon = prev.cinnamon.overrideScope (
      cfinal: cprev: {
        nemo = cprev.nemo.overrideAttrs (attrs: {
          patches = (attrs.patches or [ ]) ++ [
            # https://github.com/NixOS/nixpkgs/issues/212740
            # ./patches/nemo-no-widget-destroy.patch
            # Don't tie the interactive search box with the window's lifetime
            # https://github.com/linuxmint/nemo/issues/3423
            (prev.fetchpatch {
              url = "https://github.com/linuxmint/nemo/commit/055b47af0e1a830e556989372f3689bbd36b639d.patch";
              hash = "sha256-cMtBz1uLGCV4nnrBITzXAV/SffI0nNcEdeujrHxAzQc=";
            })
          ];
        });
      }
    );
    p7zip = prev.p7zip.override { enableUnfree = true; };
    # example = prev.example.overrideAttrs (oldAttrs: let ... in {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  # When applied, the dev/master nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.dev'
  dev-packages = final: _prev: {
    dev = import inputs.nixpkgs-dev {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
