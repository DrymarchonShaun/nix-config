{ pkgs, configVars, ... }:
{
  # Must be installed at the system level
  # https://discourse.nixos.org/t/ssl-peer-certificate-or-ssh-remote-key-was-not-ok-when-launching-steam/40274
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.unstable.proton-ge-bin ];
    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
          gamemode
          gamemode.lib
          gamescope
          mangohud
        ];
    };
  };
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope;
    capSysNice = true;
  };
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        reaper_freq = 5;
        desiredgov = "performance";

        igpu_desiredgov = "performance";
        igpu_power_threshold = 0.3;

        softrealtime = "on";

        renice = 0;

        ioprio = 0;
        inhibit_screensaver = 1;
      };
    };
  };
  environment.variables = {
    STEAM_FORCE_DESKTOPUI_SCALING = configVars.scaling;
  };

  #TODO
  # path-of-building
  # awakened-poe-trade
}
