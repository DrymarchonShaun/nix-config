{ pkgs, config, ... }:
{
  hardware.xone.enable = true; # xbox controller
  
  # required for star citizen
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
  };


  programs = {
    steam = {
      enable = true;
      protontricks = {
        enable = true;
        package = pkgs.protontricks;
      };
      package = pkgs.steam.override {
        extraPkgs =
          pkgs:
          (builtins.attrValues {
            inherit (pkgs.xorg)
              libXcursor
              libXi
              libXinerama
              libXScrnSaver
              ;

            inherit (pkgs.stdenv.cc.cc)
              lib
              ;

            inherit (pkgs)
              libpng
              libpulseaudio
              libvorbis
              libkrb5
              keyutils
              gperftools
              ;
          });
      };
      extraCompatPackages = [ pkgs.unstable.proton-ge-bin ];
      remotePlay.openFirewall = true;
    };
    #gamescope launch args set dynamically in home/<user>/common/optional/gaming
    gamescope = {
      enable = true;
      # capSysNice = true;
    };
    # to run steam games in game mode, add the following to the game's properties from within steam
    # gamemoderun %command%
    gamemode = {
      enable = true;
      settings = {
        #see gamemode man page for settings info
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
  users.users.${config.hostSpec.username}.extraGroups = [
    "gamemode"
  ];

}
