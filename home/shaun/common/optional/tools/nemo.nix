{ pkgs, lib, config, ... }:
{
  home.packages = [ pkgs.cinnamon.nemo-with-extensions ];
  dconf.settings = lib.mkIf config.programs.foot.enable {
    "org/cinnamon/desktop/applications/terminal".exec = "foot";
    "org/cinnamon/desktop/default-applications/terminal".exec = "foot";
  };
}
