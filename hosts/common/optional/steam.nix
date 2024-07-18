{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.unstable.proton-ge-bin ];
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
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
        unstable.gamescope
        mangohud
      ];
    };
  };
  programs.gamescope = {
    enable = true;
    package = pkgs.unstable.gamescope;
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
}
