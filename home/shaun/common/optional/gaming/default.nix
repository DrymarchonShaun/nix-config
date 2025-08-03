# This module just provides a customized .desktop file with gamescope args dynamically created based on the
# host's monitors configuration
{
  pkgs,
  ...
}:
{
  imports = [
    ./mangohud.nix
  ];

  home.packages = [
    pkgs.ckan
    pkgs.lug-helper
    pkgs.dev.gamma-launcher
    pkgs.heroic
    (pkgs.prismlauncher.override {
      jdks = builtins.attrValues {
        inherit (pkgs)
          temurin-bin-8
          temurin-bin-11
          temurin-bin-17
          temurin-bin
          ;
      };
    })
  ];
}
