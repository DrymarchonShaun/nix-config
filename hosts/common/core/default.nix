# IMPORTANT: This is used by NixOS and nix-darwin so options must exist in both!
{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  isDarwin,
  ...
}:
let
  platform = if isDarwin then "darwin" else "nixos";
  platformModules = "${platform}Modules";
in
{
  imports = lib.flatten [
    inputs.home-manager.${platformModules}.home-manager
    inputs.sops-nix.${platformModules}.sops

    (map lib.custom.relativeToRoot [
      "modules/common"
      "modules/hosts/common"
      "modules/hosts/${platform}"
      "hosts/common/core/${platform}.nix"
      "hosts/common/core/sops.nix" # Core because it's used for backups, mail
      # "hosts/common/core/ssh.nix"
      #"hosts/common/core/services" #not used yet
      "hosts/common/core/services/remote-builders.nix" # not used yet
      "hosts/common/users/primary"
      "hosts/common/users/primary/${platform}.nix"
    ])
  ];

  #
  # ========== Core Host Specifications ==========
  #
  hostSpec = {
    username = "shaun";
    handle = "DrymarchonShaun";
    inherit (inputs.nix-secrets)
      domain
      email
      userFullName
      usernames
      networking
      latitude
      longitude
      ;
  };

  networking.hostName = config.hostSpec.hostName;

  # System-wide packages, in case we log in as root
  environment.systemPackages = [ pkgs.openssh ];

  # Force home-manager to use global packages
  home-manager.useGlobalPkgs = true;
  # If there is a conflict file that is backed up, use this extension
  home-manager.backupFileExtension = "bk";
  # home-manager.useUserPackages = true;

  #
  # ========== Overlays ==========
  #
  nixpkgs = {
    overlays = [
      outputs.overlays.default
      inputs.rust-overlay.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  #
  # ========== Nix Nix Nix ==========
  #
  nix = {
    # package = lib.mkDefault pkgs.nixVersions.latest;
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    extraOptions = ''
      !include ${config.sops.templates."nix-github-token.conf".path}
    '';

    settings = {
      # See https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000; # 128MB
      max-free = 5000000000; # 5GB

      trusted-users = [ "@wheel" ];
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      warn-dirty = false;

      allow-import-from-derivation = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  #
  # ========== Basic Shell Enablement ==========
  #
  # On darwin it's important this is outside home-manager
  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAliases = {
      # Overrides those provided by plugins, and themes.
      # For a full list of active aliases, run `alias`.

      #------------Navigation------------
      l = "eza -lah";
      la = "eza -lah";
      ll = "eza -lh";
      ls = "eza";
      lsa = "eza -lah";
    };
  };
}
