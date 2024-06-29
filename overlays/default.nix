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
        patches = attrs.patches ++ [ ./patches/edk2-to-am.patch ];
      });
    };
    qemu_kvm = prev.qemu_kvm.overrideAttrs {
      pipewireSupport = true;
      patches = [
        ./patches/qemu-anti-detection.patch
      ];
    };
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
