{ pkgs, ... }:
{
  home.packages = [
    pkgs.arma3-unix-launcher
    (pkgs.arma3-unix-launcher.override { buildDayZLauncher = true; })
    pkgs.gamma-launcher
    pkgs.unstable.gamescope
  ];
}
