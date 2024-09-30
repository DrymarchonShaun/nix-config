#
# This file defines overlays/custom modifications to upstream packages
#

{ inputs, ... }:
let
  nixpkgs-gamescope = import inputs.nixpkgs-gamescope { system = "x86_64-linux"; };
in
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
        #patches = (attrs.patches or [ ]) ++ [ ./patches/edk2-to-am.patch ];
      });
    };
    qemu_kvm = prev.qemu_kvm.overrideAttrs (attrs: {
      pipewireSupport = true;
      #patches = (attrs.patches or [ ]) ++ [ ./patches/qemu-anti-detection.patch ];
    });

    p7zip = prev.p7zip.override { enableUnfree = true; };

    orca-slicer = prev.orca-slicer.overrideAttrs (attrs: {
      version = "2.2.0-beta";
      src = attrs.src // {
        rev = "v2.2.0-beta";
        hash = "";
      };
    });

    gamescope = nixpkgs-gamescope.gamescope;

    #sway-contrib.grimshot = prev.sway-contrib.grimshot.overrideAttrs (attrs: {
    #  patches = (attrs.patches or [ ]) ++ [ ./patches/grimshot-application-name.patch ];
    #});
    # example = prev.example.overrideAttrs (oldAttrs: let ... in {
    # ...
    # });
  };
  # kernelOverrides = final: prev: {
  # linuxPackages = prev.linuxPackages.extend (
  #  lpself: lpsuper: {
  #    system76 = prev.linuxPackages.system76.overrideAttrs (
  #      attrs:
  #      {
  #      }
  #    );
  #  }
  #);
  #};

  #
  # Convenient access to stable or unstable nixpkgs regardless
  #
  # When applied, the nixpkgs-stable set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'. Likewise, the nixpkgs-unstable set
  # will be accessible through 'pkgs.unstable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  # When applied, the dev/master nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.master'
  master-packages = final: _prev: {
    master = import inputs.nixpkgs-master {
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
