# You can build these directly using 'nix build .#example'

{
  pkgs ? import <nixpkgs> { },
}:
rec {

  #################### Packages with external source ####################
  cd-gitroot = pkgs.callPackage ./cd-gitroot { };
  discord-patched-launcher = pkgs.callPackage ./discord-patched-launcher.nix { };
  fae-linux = pkgs.callPackage ./fae-linux { };
  import-gsettings = pkgs.callPackage ./import-gsettings.nix { };
  rofi-randr = pkgs.callPackage ./rofi-randr { };
  swaync-catppuccin = pkgs.callPackage ./swaync-catppuccin { };
  syncthing-resolve-conflicts = pkgs.callPackage ./syncthing-resolve-conflicts { };
  wallpapers = pkgs.callPackage ./wallpapers { };
  zsh-auto-notify = pkgs.callPackage ./zsh-auto-notify { };
  zsh-term-title = pkgs.callPackage ./zsh-term-title { };
  gamma-launcher = pkgs.callPackage ./gamma-launcher { };
}
