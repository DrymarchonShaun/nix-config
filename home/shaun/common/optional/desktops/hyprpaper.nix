{ pkgs, ... }:
{
  home.packages = [ pkgs.hyprpaper ];
  home.file."hyprpaper.conf" = {
    text = ''
      preload = ${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin.png
      wallpaper = ,${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin.png
    '';
    target = ".config/hypr/hyprpaper.conf";
  };
}
