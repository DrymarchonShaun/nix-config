{ pkgs, lib, config, ... }:
{
  config = {
    home.packages = [ pkgs.cinnamon.nemo-with-extensions ];
  } ++ lib.mkIf config.programs.foot.enable {
    dconf.settings."org/cinnamon/desktop/applications/terminal".exec = "foot";
    dconf.settings."org/cinnamon/desktop/default-applications/terminal".exec = "foot";
  };
}
