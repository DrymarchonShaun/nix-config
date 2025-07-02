# This module just provides a customized .desktop file with gamescope args dynamically created based on the
# host's monitors configuration
{
  pkgs,
  lib,
  ...
}:

let
  defaultOptions =
    {
      gamescope ? false,
      preExtraEnvVars ? [ ],
      extraEnvVars ? [ ],
      preExtraPrefixCommand ? [ ],
      extraPrefixCommand ? [ ],
      extraGameOptions ? [ ],
    }:
    lib.concatStringsSep " " (
      lib.flatten [
        preExtraEnvVars
        (lib.optional gamescope "MANGOHUD=0")
        extraEnvVars
        preExtraPrefixCommand
        "gamemoderun"
        extraPrefixCommand
        (lib.optional gamescope "gamescope -W 2560 -H 1440 -r 165 -f --mangoapp --adaptive-sync --")
        "%command%"
        extraGameOptions
      ]
    );
in
{
  imports = [
    ./mangohud.nix
  ];

  programs.steam.launchOptions = {
    enable = true;
    options = {
      # Arma 3
      "107410" = defaultOptions { };
      # Hell Let Loose
      "686810" = defaultOptions { gamescope = true; };

      "949230" = defaultOptions {
        gamescope = true;
        extraGameOptions = [ "-dx11" ];
      };
      # Hell Divers 2
      "553850" = defaultOptions { extraEnvVars = [ "radv_force_pstate_peak_gfx11_dgpu=false" ]; };
    };
  };

  home.packages = [
    pkgs.ckan
    pkgs.lug-helper
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
