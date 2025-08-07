{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  environment.systemPackages = [ pkgs.tmux ];

  sops = {
    secrets."tokens/mc-bot-token" = { };
    templates = {
      "minecraft-secrets" = {
        owner = "minecraft";
        content = ''
          bottoken=${config.sops.placeholder."tokens/mc-bot-token"}
        '';
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      config.hostSpec.networking.ports.minecraft
      (config.hostSpec.networking.ports.minecraft + 1)
      (config.hostSpec.networking.ports.minecraft + 10)
    ];
    # required for geyser
    allowedUDPPorts = [
      (config.hostSpec.networking.ports.minecraft + 1)
      19132
    ];
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/opt/minecraft";
    environmentFile = config.sops.templates."minecraft-secrets".path;
    openFirewall = true;

    servers =
      let
        importServer = (
          name:
          import ./servers/${name}.nix {
            inherit
              pkgs
              config
              lib
              inputs
              ;
          }
        );
      in
      {
        "main" = importServer "main";
        # "bedrock" = importServer "bedrock";
      };
  };
}
