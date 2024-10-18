{
  inputs,
  config,
  configVars,
  pkgs,
  lib,
  ...
}:
{
  nix = {
    package = lib.mkDefault pkgs.nixVersions.latest;
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    buildMachines = [
      # corais
      {
        system = "x86_64-linux";
        sshUser = "nixremote";
        sshKey = "/home/nixremote/.ssh/id_dvergar";
        speedFactor = 2;
        hostName = "corais.local";
      }
      #natrix
      {
        system = "x86_64-linux";
        sshUser = "nixremote";
        sshKey = "/home/nixremote/.ssh/id_dvergar";
        speedFactor = 1;
        hostName = "natrix.local";
      }
    ];
    distributedBuilds = true;
    # optional, useful when the builder has a faster internet connection than yours
    extraOptions = ''
      !include ${config.sops.templates."nix-github-token.conf".path}
      builders-use-substitutes = true
    '';
    settings = {
      # See https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 50;
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB

      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      flake-registry = ""; # Disable global flake registry
    };

    # Garbage Collection
    # Disabled here in favor of using nh based gc. See hosts/common/core/default.nix
    #    gc = {
    #      automatic = true;
    #      options = "--delete-older-than 10d";
    #    };
  };
}
