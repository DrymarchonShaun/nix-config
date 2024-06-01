{
  imports = [
    # Packages with custom configs go here

    #./hyprland
    # ./hyprpaper.nix

    ########## Utilities ##########
    #./services/swaync.nix # Notification daemon
    #./services/wl-paste.nix # Clipboard functionality
    #./waybar.nix # infobar
    #./monitors.nix
    # ./swayidle.nix
    #./swaylock.nix
    #./rofi.nix
    #./tray.nix
    #./rofi-wayland.nix #app launcher
    #./swww.nix #wallpaper daemon

    ./gtk.nix # mainly in gnome
    ./qt.nix # mainly in kde
    #./fonts.nix
  ];
}
