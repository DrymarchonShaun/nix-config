{ pkgs, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      # preload = [ "${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin.png" ];
      preload = [ "${pkgs.wallpapers}/share/backgrounds/starcitizen-spacec-station.png" ];

      wallpaper = [
        # ",${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin.png"
        ",${pkgs.wallpapers}/share/backgrounds/starcitizen-spacec-station.png"

      ];
    };
  };
}
