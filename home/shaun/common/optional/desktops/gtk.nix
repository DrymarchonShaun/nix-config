{ config, pkgs, lib, ... }:

{
  gtk = {
    enable = true;
    #font.name =  TODO see misterio https://github.com/Misterio77/nix-config/blob/f4368087b0fd0bf4a41bdbf8c0d7292309436bb0/home/misterio/features/desktop/common/gtk.nix   he has a custom config for managing fonts, colorsheme etc.
    catppuccin = {
      enable = true;
      cursor.enable = true;
    };
    #theme = {
    #  name = "Catppuccin-Macchiato-Standard-Blue-Dark";
    #  package = pkgs.catppuccin-gtk.override {
    #    accents = [ "blue" ];
    #    size = "standard";
    #    tweaks = [ "normal" ];
    #    variant = "macchiato";
    #  };
    #};

    #iconTheme = {
    #  name = "Papirus-Dark";
    #  package = pkgs.papirus-icon-theme;
    #};

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  home = {
    pointerCursor = {
      name = "Catppuccin-Macchiato-Blue-Cursors";
      package = pkgs.catppuccin-cursors.macchiatoBlue;
      size = 18;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
