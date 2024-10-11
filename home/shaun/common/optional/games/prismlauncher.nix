{ pkgs, ... }:
{
  home.packages = [
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
