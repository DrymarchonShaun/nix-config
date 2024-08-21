{ pkgs, ... }:
{
  home.packages = [
    pkgs.unstable.arma3-unix-launcher
    (pkgs.unstable.arma3-unix-launcher.override { buildDayZLauncher = true; })
    pkgs.gamma-launcher
    pkgs.unstable.gamescope
  ];
}
