{
  imports = [
    # Packages with custom configs go here

    ./hyprland

    ########## Utilities ##########
    ./services/dunst.nix # Notification daemon
    ./waybar.nix # infobar
    ./swayidle.nix
    ./swaylock.nix
    ./rofi.nix
    #./rofi-wayland.nix #app launcher
    #./swww.nix #wallpaper daemon

    ./gtk.nix # mainly in gnome
    ./qt.nix # mainly in kde
    #./fonts.nix
  ];
}
