{
  pkgs,
  config,
  ...
}:
let

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
          "107410" = { };
          # Hell Let Loose
          "686810" = {
            gamescope = true;
          };
          # SCP 5K
          "872670" = {
            gamescope = true;
            captureCursor = true;
            extraGameOptions = [
              "-dx11"
              "-nostartupmovies"
            ];
          };
          "949230" = {
            gamescope = true;
            extraGameOptions = [ "-dx11" ];
          };
          # Hell Divers 2
          "553850" = {
            extraEnvVars = [ "radv_force_pstate_peak_gfx11_dgpu=false" ];
          };
          # Command Modern Operations
          "1076160" = {
            gamescope = true;
          };
          # Ready or Not
          "1144200" = {
            extraEnvVars = [ "PROTON_SET_GAME_DRIVE=1" ];
          };

          # Bioshock Remastered
          "409710" = {
            gamescope = true;
            captureCursor = true;
          };

          # Out of Ore
          "2009350" = {
            preExtraPrefixCommand = [
              "sed -i 's/FrameRateLimit=60.000000/FrameRateLimit=165.000000/' $STEAM_COMPAT_DATA_PATH/pfx/drive_c/users/steamuser/AppData/Local/OutOfOre/Saved/Config/WindowsNoEditor/GameUserSettings.ini;"
            ];
          };

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
