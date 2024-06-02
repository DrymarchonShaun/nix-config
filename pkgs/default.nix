# You can build these directly using 'nix build .#example'

{ pkgs ? import <nixpkgs> { } }: rec {

  #################### Packages with external source ####################

  cd-gitroot = pkgs.callPackage ./cd-gitroot { };
  zhooks = pkgs.callPackage ./zhooks { };
  zsh-term-title = pkgs.callPackage ./zsh-term-title { };
  fae-linux = pkgs.callPackage ./fae-linux { };
  rofi-randr = pkgs.callPackage ./rofi-randr { };
  swaync-catppuccin = pkgs.callPackage ./swaync-catppuccin { };
  syncthing-resolve-conflicts = pkgs.callPackage ./syncthing-resolve-conflicts { };
  wallpapers = pkgs.callPackage ./wallpapers { };
  import-gsettings = pkgs.callPackage ./import-gsettings.nix { };
}
