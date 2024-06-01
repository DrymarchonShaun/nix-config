{ inputs, lib }:
{
  username = "shaun";
  handle = "DrymarchonShaun";
  #  userFullName = inputs.nix-secrets.full-name;
  #  userEmail = inputs.nix-secrets.user-email;
  #  schoolEmail = inputs.nix-secrets.school-email;
  networking = import ./networking.nix { inherit lib; };
  persistFolder = "/persist";
  isMinimal = false; # Used to indicate nixos-installer build
}
