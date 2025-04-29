{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with inputs.openmw-nix.packages.${pkgs.system}; [
    delta-plugin
    groundcoverify
    (openmw-dev.overrideAttrs { tweakedWaterShader = true; })
    openmw-validator
    plox
    (umo.overrideAttrs (oldAttrs: {
      version = "0.8.23";
      src = pkgs.fetchFromGitLab {
        owner = "modding-openmw";
        repo = "umo";
        tag = "0.8.23";
        sha256 = "sha256-avppw5fWO7iomKw6VrVWGV6je3HA1RWICa0+mpyfxLI=";
      };

      patches = (oldAttrs.patches or [ ]) ++ [
        (lib.custom.relativeToRoot "overlays/umo-version-fix.patch")
      ];

    }))
    pkgs.s3lightfixes
    pkgs.momw-configurator
    pkgs.tes3cmd
  ];
}
