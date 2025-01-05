{
  config,
  lib,
  pkgs,
  ...
}:
let
  defaultBuildConfig = {
    sshUser = "nixbuilder";
    sshKey = config.sops.secrets."keys/ssh/dvergar".path;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    protocol = "ssh-ng";
    maxJobs = 8;
    speedFactor = 0;
    supportedFeatures = [
      "nixos-test"
      "benchmark"
      "big-parallel"
      "kvm"
    ];
    mandatoryFeatures = [ ];
  };
  hosts = [
    # Servers First
    # {
    #   hostName = "syno-vm";
    #   speedFactor = 2;
    #   maxJobs = 4;
    # }

    # Then Desktops
    {
      hostName = "corais";
      speedFactor = 8;
      maxJobs = 12;
    }
    {
      hostName = "natrix";
      speedFactor = 6;
      maxJobs = 8;
    }
  ];
  sshHostsConfig = builtins.map (host: ''
    Host ${host.hostName}
      HostName ${host.hostName}.${config.hostSpec.domain}
      UpdateHostkeys yes
      StrictHostKeyChecking=accept-new
      ConnectTimeout=1
      ConnectionAttempts=1
  '') build_hosts;
  sshConfigString = lib.concatStringsSep "\n" sshHostsConfig;
  filtered_hosts = builtins.filter (host: config.networking.hostName != host.hostName) hosts;
  build_hosts = builtins.map (host: defaultBuildConfig // host) filtered_hosts;
in
{
  users.users.nixbuilder = {
    isNormalUser = true;
    description = "nixbuilder";
    group = "nixbuilder";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGqPA1toSNUi67SSGtgnvxe39AwGuKI5kdOlFm6Me2O id_dvergar"
    ];
  };
  users.groups.nixbuilder = { };
  sops.secrets."keys/ssh/dvergar" = { };
  nix.buildMachines = build_hosts;
  programs.ssh.extraConfig = sshConfigString;

  nix.distributedBuilds = true;
  nix.settings = {
    builders-use-substitutes = true;
    trusted-users = [ "nixbuilder" ];
    # TODO: set up builders as substituters
    #   trusted-public-keys = [];
  };
}
