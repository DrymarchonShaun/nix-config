# home level sops. see hosts/common/optional/sops.nix for hosts level
# TODO should I split secrtets.yaml into a home level and a hosts level or move to a single sops.nix entirely?

{ inputs, config, ... }:
let
  secretspath = builtins.toString inputs.mysecrets;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    # gnupg = {
    #   home = "/var/lib/sops";
    #   sshKeyPaths = [ ];
    # }

    # This is the ta/dev key and needs to have been copied to this location on the host
    age.keyFile = "/home/shaun/.config/sops/age/keys.txt";

    defaultSopsFile = "${secretspath}/secrets.yaml";
    #    defaultSopsFile = ../../../../hosts/common/secrets.yaml;
    validateSopsFiles = false;

    secrets = {
      "private_keys/odin" = {
        path = "/home/shaun/.ssh/id_odin";
      };
      "private_keys/mimir" = {
        path = "/home/shaun/.ssh/id_mimir";
      };
      shaun-email = { };
      #  "private_keys/meek" = {
      #    path = "/home/shaun/.ssh/id_meek";
      #  };
    };
  };
}
