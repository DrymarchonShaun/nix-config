{ pkgs, ... }:
{
  imports = [
    ./eye-of-gnome.nix
    ./qpwgraph.nix
    ./syncthing.nix
    ./thunar.nix
    ./wine.nix
    ./xdg.nix
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs)

      # System Utilities
      mission-center

      # 3D Printing
      freecad
      orca-slicer
      openscad-unstable
      blender

      # Productivity
      libreoffice
      drawio

      # imaging
      rpi-imager
      #etcher #was disable in nixpkgs due to dependency on insecure version of Electron

      # media production
      audacity
      gimp
      inkscape

      ;
  };
}
