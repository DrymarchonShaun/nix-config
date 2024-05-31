{ ... }: {
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/epub+zip" = [ "calibre-gui.desktop" ];
        "application/illustrator" = [ "org.inkscape.Inkscape.desktop" ];
        "application/mxf" = [ "vlc.desktop" ];
        "application/octet-stream" = [ "code.desktop" ];
        "application/ogg" = [ "vlc.desktop" ];
        "application/pdf" = [ "brave-browser.desktop" ];
        "application/ram" = [ "vlc.desktop" ];
        "application/sdp" = [ "vlc.desktop" ];
        "application/vnd.adobe.flash.movie" = [ "vlc.desktop" ];
        "application/vnd.amazon.mobi8-ebook" = [ "calibre-gui.desktop" ];
        "application/vnd.apple.mpegurl" = [ "vlc.desktop" ];
        "application/vnd.comicbook-rar" = [ "calibre-gui.desktop" ];
        "application/vnd.comicbook+zip" = [ "calibre-gui.desktop" ];
        "application/vnd.corel-draw" = [ "org.inkscape.Inkscape.desktop" ];
        "application/vnd.ms-asf" = [ "vlc.desktop" ];
        "application/vnd.ms-wpl" = [ "vlc.desktop" ];
        "application/vnd.rn-realmedia" = [ "vlc.desktop" ];
        "application/vnd.visio" = [ "org.inkscape.Inkscape.desktop" ];
        "application/x-cb7" = [ "calibre-gui.desktop" ];
        "application/x-cd-image" = [ "vlc.desktop" ];
        "application/x-gnome-saved-search" = [ "nemo.desktop" ];
        "application/x-kicad-project" = [ "org.kicad.kicad.desktop" ];
        "application/x-matroska" = [ "vlc.desktop" ];
        "application/x-mobipocket-ebook" = [ "calibre-gui.desktop" ];
        "application/x-mobipocket-subscription" = [ "calibre-gui.desktop" ];
        "application/x-modrinth-modpack+zip" = [ "org.prismlauncher.PrismLauncher.desktop" ];
        "application/x-ms-dos-executable" = [ "wine.desktop" ];
        "application/x-quicktime-media-link" = [ "vlc.desktop" ];
        "application/x-shorten" = [ "vlc.desktop" ];
        "application/x-sony-bbeb" = [ "calibre-gui.desktop" ];
        "application/x-xpinstall" = [ "brave-browser.desktop" ];
        "application/x-zerosize" = [ "code.desktop" ];
        "application/xhtml+xml" = [ "brave-browser.desktop" ];
        "application/xml" = [ "code.desktop" ];
        "application/xspf+xml" = [ "vlc.desktop" ];
        "application/zip" = [ "org.gnome.FileRoller.desktop" ];
        "audio/aac" = [ "vlc.desktop" ];
        "audio/ac3" = [ "vlc.desktop" ];
        "audio/AMR-WB" = [ "vlc.desktop" ];
        "audio/AMR" = [ "vlc.desktop" ];
        "audio/basic" = [ "vlc.desktop" ];
        "audio/flac" = [ "vlc.desktop" ];
        "audio/midi" = [ "vlc.desktop" ];
        "audio/mp2" = [ "vlc.desktop" ];
        "audio/mp4" = [ "vlc.desktop" ];
        "audio/mpeg" = [ "vlc.desktop" ];
        "audio/ogg" = [ "vlc.desktop" ];
        "audio/vnd.dts.hd" = [ "vlc.desktop" ];
        "audio/vnd.dts" = [ "vlc.desktop" ];
        "audio/vnd.rn-realaudio" = [ "vlc.desktop" ];
        "audio/webm" = [ "vlc.desktop" ];
        "audio/x-adpcm" = [ "vlc.desktop" ];
        "audio/x-aiff" = [ "vlc.desktop" ];
        "audio/x-ape" = [ "vlc.desktop" ];
        "audio/x-gsm" = [ "vlc.desktop" ];
        "audio/x-it" = [ "vlc.desktop" ];
        "audio/x-matroska" = [ "vlc.desktop" ];
        "audio/x-mod" = [ "vlc.desktop" ];
        "audio/x-mpegurl" = [ "vlc.desktop" ];
        "audio/x-ms-asx" = [ "vlc.desktop" ];
        "audio/x-ms-wma" = [ "vlc.desktop" ];
        "audio/x-musepack" = [ "vlc.desktop" ];
        "audio/x-s3m" = [ "vlc.desktop" ];
        "audio/x-scpls" = [ "vlc.desktop" ];
        "audio/x-speex" = [ "vlc.desktop" ];
        "audio/x-tta" = [ "vlc.desktop" ];
        "audio/x-vorbis+ogg" = [ "vlc.desktop" ];
        "audio/x-wav" = [ "vlc.desktop" ];
        "audio/x-wavpack" = [ "vlc.desktop" ];
        "audio/x-xm" = [ "vlc.desktop" ];
        "image/cgm" = [ "org.inkscape.Inkscape.desktop" ];
        "image/svg+xml-compressed" = [ "org.inkscape.Inkscape.desktop" ];
        "image/svg+xml" = [ "org.inkscape.Inkscape.desktop" ];
        "image/vnd.rn-realpix" = [ "vlc.desktop" ];
        "image/wmf" = [ "org.inkscape.Inkscape.desktop" ];
        "image/x-eps" = [ "org.inkscape.Inkscape.desktop" ];
        "inode/directory" = [ "nemo.desktop" ];
        "text/html" = [ "brave-browser.desktop" ];
        "text/plain" = [ "code.desktop" ];
        "text/x-google-video-pointer" = [ "vlc.desktop" ];
        "text/x-log" = [ "code.desktop" ];
        "video/3gpp" = [ "vlc.desktop" ];
        "video/3gpp2" = [ "vlc.desktop" ];
        "video/dv" = [ "vlc.desktop" ];
        "video/mp2t" = [ "vlc.desktop" ];
        "video/mp4" = [ "vlc.desktop" ];
        "video/mpeg" = [ "vlc.desktop" ];
        "video/ogg" = [ "vlc.desktop" ];
        "video/quicktime" = [ "vlc.desktop" ];
        "video/vnd.mpegurl" = [ "vlc.desktop" ];
        "video/vnd.rn-realvideo" = [ "vlc.desktop" ];
        "video/webm" = [ "vlc.desktop" ];
        "video/x-anim" = [ "vlc.desktop" ];
        "video/x-flic" = [ "vlc.desktop" ];
        "video/x-flv" = [ "vlc.desktop" ];
        "video/x-matroska" = [ "vlc.desktop" ];
        "video/x-ms-wmv" = [ "vlc.desktop" ];
        "video/x-msvideo" = [ "vlc.desktop" ];
        "video/x-nsv" = [ "vlc.desktop" ];
        "video/x-ogm+ogg" = [ "vlc.desktop" ];
        "video/x-theora+ogg" = [ "vlc.desktop" ];
        "x-content/audio-cdda" = [ "vlc.desktop" ];
        "x-content/audio-player" = [ "vlc.desktop" ];
        "x-content/video-dvd" = [ "vlc.desktop" ];
        "x-content/video-svcd" = [ "vlc.desktop" ];
        "x-content/video-vcd" = [ "vlc.desktop" ];
        "x-scheme-handler/calibre" = [ "calibre-gui.desktop" ];
        "x-scheme-handler/http" = [ "brave-browser.desktop" ];
        "x-scheme-handler/https" = [ "brave-browser.desktop" ];
        "x-scheme-handler/icy" = [ "vlc.desktop" ];
        "x-scheme-handler/icyx" = [ "vlc.desktop" ];
        "x-scheme-handler/mms" = [ "vlc.desktop" ];
        "x-scheme-handler/mmsh" = [ "vlc.desktop" ];
        "x-scheme-handler/rtmp" = [ "vlc.desktop" ];
        "x-scheme-handler/rtp" = [ "vlc.desktop" ];
        "x-scheme-handler/rtsp" = [ "vlc.desktop" ];
        "x-scheme-handler/steam" = [ "steam.desktop" ];
        "x-scheme-handler/steamlink" = [ "steam.desktop" ];
        "x-scheme-handler/vscode" = [ "code-uri-handler.desktop" ];
      };
    };
  };
} 
