{ config, ... }:
{
  users.users.${config.hostSpec.username}.extraGroups = [
    "networkmanager"
  ];
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
        }) config.hostSpec.networking.connections
      );
    };
  };
}
