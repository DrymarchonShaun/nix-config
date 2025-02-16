{ pkgs, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [ "${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin.png" ];

      wallpaper = [
        ",${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin.png"
      ];
    };
  };
}
