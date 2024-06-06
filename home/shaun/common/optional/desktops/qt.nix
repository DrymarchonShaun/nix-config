{ pkgs, ... }:
{

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      name = "kvantum";
      catppuccin.enable = true;
    };
  };
}
