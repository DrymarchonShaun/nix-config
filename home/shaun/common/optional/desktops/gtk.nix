{
  config,
  pkgs,
  lib,
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
  gtk = {
    enable = true;
    #font.name =  TODO see misterio https://github.com/Misterio77/nix-config/blob/f4368087b0fd0bf4a41bdbf8c0d7292309436bb0/home/misterio/features/desktop/common/gtk.nix   he has a custom config for managing fonts, colorsheme etc.
    catppuccin = {
      enable = false;
      icon.enable = true;
    };
    theme.name = "adw-gtk3-dark";
    theme.package = pkgs.adw-gtk3;

    #theme = {
    #  name = "Catppuccin-Macchiato-Standard-Blue-Dark";
    #  package = pkgs.catppuccin-gtk.override {
    #    accents = [ "blue" ];
    #    size = "standard";
    #    tweaks = [ "normal" ];
    #    variant = "macchiato";
    #  };
    #};

    # iconTheme = {
    #   name = "Papirus-Dark";
    #   package = pkgs.catppuccin-papirus-folders.override { inherit (config.gtk.catppuccin.icon) accent flavor; };
    # };

    gtk3 = {
      extraCss = builtins.readFile "${gradienceBuild}/gtk-3.0/gtk.css";
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4 = {
      extraCss = builtins.readFile "${gradienceBuild}/gtk-4.0/gtk.css";
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
  catppuccin.pointerCursor.enable = true;
  home.pointerCursor = {
    size = 28;
    gtk.enable = true;
    x11.enable = true;
  };
}
