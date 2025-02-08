{ pkgs, ... }:
{
  home.packages = [ pkgs.unstable.ghostty ];

  xdg.configFile."ghostty/config".text = ''
    theme = catppuccin-macchiato
    window-decoration = false
    background-opacity = 0.6
  '';
}
