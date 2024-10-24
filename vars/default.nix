{ inputs, lib }:
{
  inherit (inputs.nix-secrets)
    userFullName
    domain
    email
    networking
    latitude
    longitude
    ;

  username = "shaun";
  handle = "DrymarchonShaun";
  gitHubEmail = "40149778+DrymarchonShaun@users.noreply.github.com";
  persistFolder = "/persist";

  # System-specific settings (FIXME: Likely make options)
  isMinimal = false; # Used to indicate nixos-installer build
  isWork = false; # Used to indicate a host that uses work resources
  scaling = "1"; # Used to indicate what scaling to use. Floating point number
}

# README
#
# Many of the values here come from my private nix-secrets repository.
# While the primary purpose of nix-secrets is storing sensitive data
# encrypted using sops, less-senstive data are simply stored in a simple
# nix-secrets/flake.nix so they can be kept private but retrieved here
# without the overhead of sops
#
# For reference the basic example structure of my nix-secrets/flake.nix is as follows:
#
#{
#  outputs = {...}:
#    {
#        domain = "";
#        userFullName = "";
#        email = {
#            user = "";
#            work = "";
#        };
#        networking = {
#            subnets = {
#                foo = {
#                    name = "foo";
#                    ip = "0.0.0.0";
#                };
#            };
#            external = {
#                bar = {
#                    name = "bar";
#                    ip = "0.0.0.0";
#                };
#            };
#            ports = {
#                tcp = {
#                    ssh = 22;
#                };
#            };
#        };
#
#    };
#}
