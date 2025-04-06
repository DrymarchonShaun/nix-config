{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.polychromatic
  ];

  custom.hardware.openrazer = {
    enable = true;
    users = [ config.hostSpec.username ];

    # override the kernel package to add support for the naga v2 pro
    package = config.boot.kernelPackages.openrazer.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "openrazer";
        repo = "openrazer";
        rev = "refs/pull/2348/head";
        hash = "sha256-S7zNGihLJ2vfvGqm+ZbbxMB/FsY9XSVrtBvLeKNwHjc=";
      };
    });
  };
}
