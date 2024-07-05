{ pkgs
, lib
, config
, ...
}:
{
  home.packages = [
    pkgs.cinnamon.nemo-with-extensions
    pkgs.gnome.file-roller
  ];
  dconf.settings = lib.mkIf config.programs.foot.enable {
    "org/cinnamon/desktop/applications/terminal".exec = "foot";
    "org/cinnamon/desktop/default-applications/terminal".exec = "foot";
  };
}
