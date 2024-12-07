{ pkgs, ... }:
{
  #imports = [ ./foo.nix ];

  home.packages = builtins.attrValues {
    inherit (pkgs)

      ffmpeg
      yt-dlp
      spotify
      vlc
      calibre
      ;
  };
}
