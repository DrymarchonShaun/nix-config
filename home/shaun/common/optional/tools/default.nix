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

      # 3D Printing
      orca-slicer
      freecad
      openscad-unstable

      # Productivity
      libreoffice
      drawio

      # imaging
      rpi-imager
      #etcher #was disable in nixpkgs due to depency on insecure version of Electron

      # media production
      audacity
      blender
      gimp
      inkscape

      ;
  };
}
