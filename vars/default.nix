{ inputs, lib }:
{
  gpgKey = "E1EC37451A645A64!";
  username = "shaun";
  domain = inputs.nix-secrets.domain;
  userFullName = inputs.nix-secrets.full-name;
  handle = "DrymarchonShaun";
  userEmail = inputs.nix-secrets.user-email;
  gitHubEmail = "40149778+DrymarchonShaun@users.noreply.github.com";
  # gitLabEmail = "2889621-emergentmind@users.noreply.gitlab.com";
  workEmail = inputs.nix-secrets.work-email;
  persistFolder = "/persist";

  # System-specific settings (FIXME: Likely make options)
  isMinimal = false; # Used to indicate nixos-installer build
  isWork = false; # Used to indicate a host that uses work resources
  scaling = "1"; # Used to indicate what scaling to use. Floating point number
}
