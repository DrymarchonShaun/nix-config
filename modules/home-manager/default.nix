# Add your reusable home-manager modules to this directory, on their own file (https://wiki.nixos.org/wiki/NixOS_modules).
# These should be stuff you would like to share with others, not your personal configurations.

{
  yubikey-touch-detector = import ./yubikey-touch-detector.nix;
  copyq = import ./copyq.nix;
}
