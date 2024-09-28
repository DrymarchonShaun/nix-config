{
  description = "DrymarchonShaun's Nix-Config";

  inputs = {
    #################### Official NixOS and HM Package Sources ####################

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # These are for pinning to stable vs unstable regardless of what the above is set to
    # See also 'stable-packages' and 'unstable-packages' overlays at 'overlays/default.nix"
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # also see 'unstable-packages' overlay at 'overlays/default.nix"
    nixpkgs-master.url = "github:NixOS/nixpkgs/master"; # also see 'master-packages' overlay at 'overlays/default.nix"
    nixpkgs-dev.url = "github:DrymarchonShaun/nixpkgs/dev"; # also see 'dev-packages' overlay at 'overlays/default.nix"
    nixpkgs-gamescope.url = "github:NixOS/nixpkgs/b7d82aa962dd09b4214379abbc93579d33802f9b";

    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      #url = "github:nix-community/home-manager/release-24.05";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    #################### Utilities ####################

    # Declarative partitioning and formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management. See ./docs/secretsmgmt.md
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixvim configuration
    nvix.url = "github:DrymarchonShaun/nvix";

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-index database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theme
    catppuccin.url = "github:catppuccin/nix";

    # vscode extensions/themes
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    catppuccin-vsc.url = "github:catppuccin/vscode";

    # Theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Windows management
    # for now trying to avoid this one because I want stability for my wm
    # this is the hyprland development flake package / unstable
    # hyprland = {
    #   url = "github:hyprwm/hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    #   hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };

    #################### Personal Repositories ####################

    # Private secrets repo.  See ./docs/secretsmgmt.md
    # Authenticate via ssh and use shallow clone
    nix-secrets = {
      url = "git+ssh://git@github.com/DrymarchonShaun/nix-secrets?ref=main&shallow=1";
      inputs = { };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        #"aarch64-darwin"
      ];
      inherit (nixpkgs) lib;
      configVars = import ./vars { inherit inputs lib; };
      configLib = import ./lib { inherit lib; };
      specialArgs = {
        inherit
          inputs
          outputs
          configVars
          configLib
          nixpkgs
          ;
      };
    in
    {
      # Custom modules to enable special functionality for nixos or home-manager oriented configs.
      #nixosModules = { inherit (import ./modules/nixos); };
      #homeManagerModules = { inherit (import ./modules/home-manager); };
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      # Custom modifications/overrides to upstream packages.
      overlays = import ./overlays { inherit inputs outputs; };

      templates = import ./templates { inherit inputs outputs; };

      # Custom packages to be shared or upstreamed.
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs { inherit pkgs; }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./checks { inherit inputs system pkgs; }
      );

      # Nix formatter available through 'nix fmt' https://nix-community.github.io/nixpkgs-fmt
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      # ################### DevShell ####################
      #
      # Custom shell for bootstrapping on new hosts, modifying nix-config, and secrets management

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          checks = self.checks.${system};
        in
        import ./shell.nix { inherit checks pkgs; }
      );

      #################### NixOS Configurations ####################
      #
      # Building configurations available through `just rebuild` or `nixos-rebuild --flake .#hostname`

      nixosConfigurations = {
        # System76 Darter Pro
        natrix = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            ./hosts/natrix
          ];
        };
        # Desktop
        corais = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            ./hosts/corais
          ];
        };
        # Main
        ghost = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            ./hosts/ghost
          ];
        };
        # Qemu VM dev lab
        grief = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            ./hosts/grief
          ];
        };
        # Qemu VM deployment test lab
        guppy = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            ./hosts/guppy
          ];
        };
        # Theatre - ASUS VivoPC VM40B-S081M
        gusto = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            ./hosts/gusto
          ];
        };
      };
    };
}
