{
  inputs,
  lib,
  config,
  ...
}:
let

  domains = builtins.attrValues (
    lib.filterAttrs (
      device: domain: device == config.hostSpec.hostName
    ) inputs.nix-secrets.duckdnsDomains
  );
in
{

  sops.secrets."tokens/duckdns" = {
    sopsFile = builtins.toString inputs.nix-secrets + "/sops/shared.yaml";
  };
  services.duckdns = {
    enable = lib.mkIf (domains != [ ]) true;
    tokenFile = config.sops.secrets."tokens/duckdns".path;
    domains = lib.flatten [
      domains
    ];
  };
}
