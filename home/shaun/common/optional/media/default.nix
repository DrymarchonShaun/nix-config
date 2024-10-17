{ pkgs, ... }:
{
  #imports = [ ./foo.nix ];

  home.packages = builtins.attrValues {
    inherit (pkgs)

      ffmpeg
      vlc
      ;
    inherit (pkgs.stable)
      calibre
      ;
  };
}
