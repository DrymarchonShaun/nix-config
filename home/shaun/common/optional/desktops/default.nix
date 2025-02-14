{
  imports = [
    # Packages with custom configs go here
    ./sway

    ./ghostty.nix
    ./gtk.nix # mainly in gnome
    ./qt.nix # mainly in kde
  ];
}
