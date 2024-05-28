{ inputs, lib }:
{
  username = "shaun";
  domain = inputs.nix-secrets.domain;
  userFullName = inputs.nix-secrets.full-name;
  handle = "DrymarchonShaun";
  userEmail = inputs.nix-secrets.user-email;
  #gitEmail = "";
  schoolEmail = inputs.nix-secrets.school-email;
  networking = import ./networking.nix { inherit lib; };
  persistFolder = "/persist";
  isMinimal = false; # Used to indicate nixos-installer build
}
