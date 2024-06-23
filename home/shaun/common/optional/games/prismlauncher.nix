{ pkgs, ... }: {
  home.packages = with pkgs; [
    (prismlauncher.override { jdks = [ temurin-bin-8 temurin-bin-11 temurin-bin-17 temurin-bin ]; })
  ];
}
