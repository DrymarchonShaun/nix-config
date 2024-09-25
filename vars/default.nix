{ inputs, lib }:
{
  networking = import ./networking.nix { inherit lib; };

  domain = inputs.nix-secrets.domain;
  username = "shaun";
  gpgKey = "E1EC37451A645A64!";
  handle = "DrymarchonShaun";
  userFullName = inputs.nix-secrets.full-name;
  userEmail = inputs.nix-secrets.user-email;
  gitHubEmail = "40149778+DrymarchonShaun@users.noreply.github.com";
  workEmail = inputs.nix-secrets.work-email;

  latitude = inputs.nix-secrets.latitude;
  longitude = inputs.nix-secrets.longitude;

  # System-specific settings (FIXME: Likely make options)
  isMinimal = false; # Used to indicate nixos-installer build
  isWork = false; # Used to indicate a host that uses work resources
  scaling = "1"; # Used to indicate what scaling to use. Floating point number
  persistFolder = "/persist";
}
