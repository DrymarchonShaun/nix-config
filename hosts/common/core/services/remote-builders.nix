# Remote building is configured here, along with setting up binary caches to limit rebuilds.
# see https://wiki.nixos.org/wiki/Distributed_build for more information
{
  config,
  inputs,
  lib,
  ...
}:
let
  sopsFolder = (builtins.toString inputs.nix-secrets) + "/sops";

  hosts = [
    # Servers First
    {
      hostName = "getula";
      speedFactor = 10;
      maxJobs = 12;
    }
    # Then Desktops
    {
      hostName = "corais";
      speedFactor = 8;
      maxJobs = 16;
    }
    {
      hostName = "natrix";
      speedFactor = 2;
      maxJobs = 2;
    }
  ];

  filtered_hosts = builtins.filter (host: config.networking.hostName != host.hostName) hosts;
in
{
  sops.secrets = {
    "keys/ssh/dvergar" = {
      sopsFile = "${sopsFolder}/shared.yaml";
    };
    "keys/nix_binary_cache" = { };
  };

  programs.ssh.extraConfig = lib.concatStringsSep "\n" (
    lib.flatten [
      (builtins.map (host: ''
        Match Host ${host.hostName},${host.hostName}.${config.hostSpec.domain}
          hostname ${host.hostName}.${config.hostSpec.domain}
          port ${builtins.toString config.hostSpec.networking.ports.tcp.ssh}
          forwardAgent yes
      '') filtered_hosts)
      ''
        Match User nix-ssh
          IdentitiesOnly yes
          IdentityFile ${config.sops.secrets."keys/ssh/dvergar".path}
          UpdateHostkeys yes
          StrictHostKeyChecking=accept-new
          ConnectTimeout=1
          ConnectionAttempts=1
      ''
    ]
  );

  nix = {
    distributedBuilds = true;
    sshServe = {
      enable = true;
      protocol = "ssh";
      write = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGqPA1toSNUi67SSGtgnvxe39AwGuKI5kdOlFm6Me2O id_dvergar"
      ];
    };

    settings = {
      fallback = true;

      builders-use-substitutes = true;
      trusted-users = [ "nix-ssh" ];
      # substituters = builtins.map (
      #   host: "ssh://nix-ssh@${host.hostName}.${config.hostSpec.domain}"
      # ) filtered_hosts;
      secret-key-files = [
        config.sops.secrets."keys/nix_binary_cache".path
      ];
      trusted-public-keys = [
        "getula:WJT+ARg+w5pIBBPlg0b7KlG6H9Yc55gxF76jG8lKtl0="
        "corais:b+5HYAUJ0bkvfMfTwmXNm7DlyIzIY6ojkHi5Qo+IIro="
        "natrix:vxo36tAeqze1q/lhKBSwWEbhcdwgKc47L5Z5lOoVE2w="
      ];
    };

    buildMachines = builtins.map (
      host:
      {
        sshUser = "nix-ssh";
        sshKey = config.sops.secrets."keys/ssh/dvergar".path;
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        protocol = "ssh";
        maxJobs = 8;
        speedFactor = 0;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        mandatoryFeatures = [ ];
      }
      // host
    ) filtered_hosts;
  };
}
