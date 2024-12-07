{ pkgs, ... }:
{
  imports = [
    ./syncthing.nix
    ./thunar.nix
    ./lazygit.nix
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      # Development
      tokei

      # 3D Printing
      freecad
      orca-slicer
      openscad-unstable

      # Device imaging
      rpi-imager
      #etcher #was disabled in nixpkgs due to dependency on insecure version of Electron

      # Productivity
      drawio
      libreoffice

      # Privacy
      #veracrypt
      #keepassxc

      # Web sites
      zola

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
      ;
    inherit (pkgs.wineWowPackages) stagingFull;
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };
  #Disabled for now. grimblast
  #  services.flameshot = {
  #      enable = true;
  #     package = flameshotGrim;
  #  };
}
