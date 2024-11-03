{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = [
      # pkgs.cnijfilter-mx340
      # pkgs.gutenprint
      # pkgs.gutenprintBin
    ];
    browsed.enable = true;
  };
}
