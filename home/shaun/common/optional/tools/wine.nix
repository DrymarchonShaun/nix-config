{ pkgs, ... }: {
  home.packages = with pkgs; [
    # for some ungodly reason wineWowPackages.stagingFull currently 
    # tries to compile gcc so using ubstable version for now
    unstable.wineWowPackages.stagingFull
    winetricks
  ];
}
