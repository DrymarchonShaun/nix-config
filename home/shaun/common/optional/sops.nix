# home level sops. see hosts/common/optional/sops.nix for hosts level
# TODO should I split secrets.yaml into a home level and a hosts level or move to a single sops.nix entirely?

{
  inputs,
  lib,
  config,
  ...
}:
let
  sopsFolder = (builtins.toString inputs.nix-secrets) + "/sops";
  homeDirectory = config.home.homeDirectory;
  keys = [
    "odin"
    "mimir"
  ];
  keySecrets = lib.attrsets.mergeAttrsList (
    lib.lists.map (name: {
      "keys/ssh/${name}" = {
        # FIXME: (starter-repo)
        # sopsFile = "${secretsFilePath}";
        sopsFile = "${sopsFolder}/shared.yaml";
        path = "${homeDirectory}/.ssh/id_${name}";
      };
    }) keys
  );

in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    # This is the location of the host specific age-key for ta and will to have been extracted to this location via hosts/common/core/sops.nix on the host
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";

    defaultSopsFile = "${sopsFolder}/${config.hostSpec.hostName}.yaml";
    validateSopsFiles = false;

    secrets = { } // keySecrets;
  };
}
