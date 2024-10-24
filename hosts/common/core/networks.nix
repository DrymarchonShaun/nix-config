{ config, configVars, ... }:
{
  networking.networkmanager = {
    enable = true;
    ensureProfiles = {
      environmentFiles = [
        config.sops.templates."networks.env".path
      ];
      profiles = builtins.listToAttrs (
        map (network: {
          name = network.connection.id;
          value = network;
        }) configVars.networking.connections
      );
    };
  };
}
