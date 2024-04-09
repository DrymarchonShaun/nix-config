{ pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };
  programs.kvantum = {
    enable = true;
    theme.package = pkgs.catppuccin-kvantum.override { accent = "Blue"; variant = "Macchiato"; };
    theme.name = "Catppuccin-Macchiato-Blue";
  };
}
