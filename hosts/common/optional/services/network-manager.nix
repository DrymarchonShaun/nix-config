{
  inputs,
  config,
  lib,
  ...
}:
let
  sopsFolder = builtins.toString inputs.nix-secrets + "/sops";
  connections = config.hostSpec.networking.connections;
in
{
  users.users.${config.hostSpec.username}.extraGroups = [
    "networkmanager"
  ];

  sops = {
    secrets = lib.mkMerge [
      (builtins.listToAttrs (
        map
          (connection: {
            name = "passwords/networks/${connection.connection.id}_psk";
            value = {
              sopsFile = "${sopsFolder}/shared.yaml";
            };
          })
          (
            builtins.filter (
              connection: connection ? "wifi-security" && connection."wifi-security" ? psk
            ) connections
          )
      ))
    ];
    templates."networks.env" = {
      mode = "0440";
      content = lib.concatMapStringsSep "\n" (
        connection:
        let
          id = connection.connection.id;
        in
        if connection ? "wifi-security" && connection."wifi-security" ? psk then
          "${id}_psk=${config.sops.placeholder."passwords/networks/${id}_psk"}"
        else
          ""
      ) connections;
    };
  };
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
