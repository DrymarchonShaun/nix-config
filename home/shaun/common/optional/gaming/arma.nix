{ pkgs, ... }:
{
  home.packages = [
    pkgs.dev.arma3-unix-launcher
    pkgs.arma3-teamspeak-launcher
  ];
}
