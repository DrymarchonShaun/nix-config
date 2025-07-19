{
  pkgs,
  lib,
  config,
  ...
}:
let
  defaultOptions =
    {
      gamescope ? false,
      captureCursor ? false,
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
        (lib.optional gamescope "gamescope -W 2560 -H 1440 -r 165 -f --mangoapp ${(lib.optionalString captureCursor "--force-grab-cursor")} --")
        "%command%"
        extraGameOptions
      ]
    );
in
{
  # required for star citizen
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
  };

  systemd.user.services.steam = {
    description = "Steam";
    wantedBy = [ "tray.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${config.programs.steam.package}/bin/steam";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  programs = {
    steam = {
      enable = true;
      package = pkgs.steam;
      protontricks = {
        enable = true;
        package = pkgs.protontricks;
      };
      extraCompatPackages = [ pkgs.unstable.proton-ge-bin ];
      remotePlay.openFirewall = true;
      launchOptions = {
        enable = true;
        options = {
          # Arma 3
          "107410" = defaultOptions { };
          # Hell Let Loose
          "686810" = defaultOptions { gamescope = true; };
          # SCP 5K
          "872670" = defaultOptions {
            gamescope = true;
            captureCursor = true;
            extraGameOptions = [
              "-dx11"
              "-nostartupmovies"
            ];
          };
          "949230" = defaultOptions {
            gamescope = true;
            extraGameOptions = [ "-dx11" ];
          };
          # Hell Divers 2
          "553850" = defaultOptions { extraEnvVars = [ "radv_force_pstate_peak_gfx11_dgpu=false" ]; };
          # Command Modern Operations
          "1076160" = defaultOptions {
            gamescope = true;
          };
          "1144200" = defaultOptions { };
        };
      };
    };
    gamescope = {
      enable = true;
      # capSysNice = true;
    };

    gamemode = {
      enable = true;
      settings = {
        general = {
          reaper_freq = 5;
          desiredgov = "performance";

          igpu_desiredgov = "performance";
          igpu_power_threshold = 0.3;

          renice = 0;
          ioprio = 0;
          softrealtime = "on";
          inhibit_screensaver = 1;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1; # The DRM device number on the system (usually 0), ie. the number in /sys/class/drm/card0/
          amd_performance_level = "high";
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-cpp;
    extraRules = [
      {
        "name" = "gamescope";
        "nice" = -20;
      }
      {
        "name" = "gamescope-wl";
        "nice" = -20;
      }
    ];
  };
  users.users.${config.hostSpec.username}.extraGroups = [
    "gamemode"
  ];

}
