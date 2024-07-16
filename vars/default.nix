{ inputs, lib }:
{
  username = "shaun";
  handle = "DrymarchonShaun";
  #  userFullName = inputs.nix-secrets.full-name;
  #  userEmail = inputs.nix-secrets.user-email;
  #  schoolEmail = inputs.nix-secrets.school-email;
  gpgKey = "E1EC37451A645A64!";
  gitHubEmail = "40149778+DrymarchonShaun@users.noreply.github.com";
  networking = import ./networking.nix { inherit lib; };
  persistFolder = "/persist";
  isMinimal = false; # Used to indicate nixos-installer build
}
