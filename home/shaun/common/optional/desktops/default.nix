{
  imports = [
    # Packages with custom configs go here
    # ./sway
    ./hyprland

    ./rofi.nix
    ./services/clipboard.nix # Clipboard functionality
    ./services/swaync.nix # Notification daemon
    ./tray.nix
    ./waybar.nix # infobar
    ./ghostty.nix
    ./gtk.nix # mainly in gnome
    ./qt.nix # mainly in kde
  ];
}
