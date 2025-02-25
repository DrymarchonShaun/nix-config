{ pkgs, ... }:
{
  services.swaync = {
    enable = true;
    style = pkgs.substitute {
      src = pkgs.fetchurl {
        url = "https://github.com/catppuccin/swaync/releases/download/v0.2.3/macchiato.css";
        sha256 = "sha256-LMm6nWn1JPPgj5YpppwFG3lXTtXem5atlIvqrDxd0bM=";
      };

      substitutions = [
        "--replace-warn"
        "Ubuntu Nerd Font"
        "JetBrains Mono"
      ];
    };

    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
    };
  };
}
