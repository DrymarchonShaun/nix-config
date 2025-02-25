{ pkgs, ... }:
{
  imports = [
    ./openscad.nix
    ./thunar.nix
    ./lazygit.nix
    ./easyeffects.nix
  ];

  home.packages = with pkgs; [
    # 3D Printing
    freecad
    # orca-slicer-overridden # modified .desktop file to not show up when searching for "code"

    # Device imaging
    rpi-imager

    # Productivity
    drawio
    libreoffice

    # Media production
    audacity
    blender
    gimp
    inkscape
    obs-studio
    # VM and RDP
    # remmina

    # Wine / Windows
    winetricks
    wineWowPackages.stagingFull
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };
}
