{
  pkgs,
  config,
  ...
}:
let
  gradiencePreset = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/GradienceTeam/Community/next/official/catppuccin-macchiato.json";
    hash = "sha256-FgQvmK/Pjn980o+UVc2a70kGa6sGse045zPS9hzCs14=";
  };
  gradienceBuild = pkgs.stdenv.mkDerivation {
    name = "gradience-build";
    phases = [
      "buildPhase"
      "installPhase"
    ];
    nativeBuildInputs = [ pkgs.gradience ];
    buildPhase = ''
      shopt -s nullglob
      export HOME=$TMPDIR
      mkdir -p $HOME/.config/presets
      gradience-cli apply -p ${gradiencePreset} --gtk both
    '';
    installPhase = ''
      mkdir -p $out
      cp -r .config/gtk-4.0 $out/
      cp -r .config/gtk-3.0 $out/
    '';
  };
in
{
  catppuccin = {
    gtk = {
      enable = false;
      icon.enable = true;
    };
    cursors.enable = true;
  };
  gtk = {
    enable = true;
    font.name = "Inter:medium";
    theme.name = "adw-gtk3-dark";
    theme.package = pkgs.adw-gtk3;

    gtk3 = {
      extraCss = builtins.readFile "${gradienceBuild}/gtk-3.0/gtk.css";
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        # color-scheme = "prefer-dark";
      };
      bookmarks = [
        # For some reason a "Desktop" shortcut already exists in thunar's bookmarks
        # "file://${config.xdg.userDirs.desktop} Desktop"
        "file://${config.xdg.userDirs.documents} Documents"
        "file://${config.xdg.userDirs.download} Downloads"
        "file://${config.xdg.userDirs.music} Music"
        "file://${config.xdg.userDirs.pictures} Pictures"
        "file://${config.xdg.userDirs.videos} Videos"
        "file://${config.xdg.userDirs.extraConfig.XDG_GAMES_DIR} Games"
        "file://${config.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR} Screenshots"
        "file://${config.xdg.userDirs.extraConfig.XDG_SRC_DIR}/obsidian-vault Obsidian Vaults"
        "file://${config.xdg.configHome} .config"
        "file://${config.xdg.dataHome} .local/share"
        "file://${config.xdg.userDirs.extraConfig.XDG_SRC_DIR} .src"
      ];
    };
    gtk4 = {
      extraCss = builtins.readFile "${gradienceBuild}/gtk-4.0/gtk.css";
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        color-scheme = "prefer-dark";
      };
    };
  };
  home.pointerCursor = {
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Make home manager overwrite this file since it gets modified by applications constantly
  xdg.configFile."gtk-3.0/bookmarks".force = true;
}
