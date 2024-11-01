{ pkgs, configVars, ... }:
let
  gamemode-discord-run =
    let
      gamemoded = "${pkgs.gamemode}/bin/gamemoded";
      gamemoderun = "${pkgs.gamemode}/bin/gamemoderun";
    in
    pkgs.writeScriptBin "gamemode-discord-run" ''
        DISCORD_PID=$(pgrep discord)
        function onexit {
        if [[ $(${gamemoded} -s$DISCORD_PID) == "gamemode is active and [$DISCORD_PID] is registered" ]]; then
          ${gamemoded} -r$DISCORD_PID
        fi
        ${pkgs.libnotify}/bin/notify-send "GameMode" "GameMode is now inactive"
      }
      if [[ $(${gamemoded} -s$DISCORD_PID) == "gamemode is inactive" ]]; then
      ${gamemoded} -r$DISCORD_PID && \
          ${pkgs.libnotify}/bin/notify-send "GameMode" "GameMode is now active"
      fi
      ${gamemoderun} "$@"
      trap onexit EXIT INT ABRT KILL TERM
    '';
in
{
  users.users.${configVars.username}.extraGroups = [
    "gamemode"
  ];

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
              libdecor
              libpng
              libpulseaudio
              libvorbis
              libkrb5
              keyutils
              gperftools
              gamemode
              mangohud
              gamescope
              ;

          })
          ++ [
            pkgs.gamemode.lib
          ];
      };
      extraCompatPackages = [
        (pkgs.unstable.proton-ge-bin.overrideAttrs (attrs: {
          postInstall =
            (attrs.postInstall or "")
            + ''
              sed -i \
              '/HKCU,Software\\Wine\\Fonts\\Replacements,"Palatino Linotype",,"Times New Roman"/d;
              /HKCU,Software\\Wine\\Fonts\\Replacements,"Verdana",,"Times New Roman"/d;
              /HKCU,Software\\Wine\\Fonts\\Replacements,"Segoe UI",,"Times New Roman"/d' \
              $out/files/share/wine/wine.inf
            '';
        }))
      ];
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
          gpu_device = 1;
          amd_performance_level = "high";
        };
        # custom = {
        #   start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        #   end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        # };
      };
    };
  };
}
