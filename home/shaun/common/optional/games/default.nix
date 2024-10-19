# This module just provides a customized .desktop file with gamescope args dynamically created based on the
# host's monitors configuration
{
  pkgs,
  config,
  lib,
  ...
}:

let
  monitor = lib.head (lib.filter (m: m.primary) config.monitors);

  steam-session =
    let
      gamescope = lib.concatStringsSep " " [
        "env"
        "MANGOHUD=0"
        (lib.getExe pkgs.gamescope)
        "--output-width ${toString monitor.width}"
        "--output-height ${toString monitor.height}"
        "--framerate-limit ${toString monitor.refreshRate}"
        "--prefer-output ${monitor.name}"
        "--adaptive-sync"
        "--expose-wayland"
        "--steam"
        "--mangoapp"
        #"--hdr-enabled"
      ];
      steam = lib.concatStringsSep " " [
        "steam"
      ];
    in
    pkgs.writeTextDir "share/applications/steam-session.desktop" ''
      [Desktop Entry]
      Name=Steam Session
      Exec=${gamescope} -- ${steam}
      Icon=steam
      Type=Application
    '';
in
{
  imports = [
    ./mangohud.nix
  ];
  home.packages = [
    steam-session
    pkgs.arma3-unix-launcher
    (pkgs.arma3-unix-launcher.override { buildDayZLauncher = true; })
    pkgs.gamma-launcher
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
