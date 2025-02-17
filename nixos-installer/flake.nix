{
  description = "Minimal NixOS configuration for bootstrapping systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    disko.url = "github:nix-community/disko"; # Declarative partitioning and formatting
    nvix.url = "github:DrymarchonShaun/nvix";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      minimalSpecialArgs = {
        inherit inputs outputs;
        lib = nixpkgs.lib.extend (self: super: { custom = import ../lib { inherit (nixpkgs) lib; }; });
      };

      # This mkHost is way better: https://github.com/linyinfeng/dotfiles/blob/8785bdb188504cfda3daae9c3f70a6935e35c4df/flake/hosts.nix#L358
      newConfig =
        name: disk: swapSize: useLuks:
        (
          let
            diskSpecPath =
              if useLuks then ../hosts/common/disks/btrfs-luks-disk.nix else ../hosts/common/disks/btrfs-disk.nix;
          in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = minimalSpecialArgs;
            modules = [
              inputs.disko.nixosModules.disko
              diskSpecPath
              {
                _module.args = {
                  inherit disk;
                  withSwap = swapSize > 0;
                  swapSize = builtins.toString swapSize;
                };
              }
              ./minimal-configuration.nix
              ../hosts/nixos/${name}/hardware-configuration.nix

              { networking.hostName = name; }
            ];
          }
        );
    in
    {
      nixosConfigurations = {
        # host = newConfig "name" disk" "swapSize" "useLuks"
        # Swap size is in GiB
        # genoa = newConfig "genoa" "/dev/nvme0n1" 16 true;
        # grief = newConfig "grief" "/dev/vda" 0 false;
        # guppy = newConfig "guppy" "/dev/vda" 0 false;
        # gusto = newConfig "gusto" "/dev/nvme0n1" 8 false;
        #
        # ghost = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = minimalSpecialArgs;
        #   modules = [
        #     inputs.disko.nixosModules.disko
        #     ../hosts/common/disks/ghost.nix
        #     ./minimal-configuration.nix
        #     { networking.hostName = "ghost"; }
        #     ../hosts/nixos/ghost/hardware-configuration.nix
        #   ];
        # };


        corais = newConfig "corais" "/dev/disk/by-id/nvme-eui.00253854119048ec" 24 false;
        getula = newConfig "getula" "/dev/disk/by-id/wwn-0x50026b738033a0f0" 16 false;

        natrix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = minimalSpecialArgs;
          modules = [
            inputs.disko.nixosModules.disko
            ../hosts/common/disks/natrix.nix
            ./minimal-configuration.nix
            { networking.hostName = "natrix"; }
            ../hosts/nixos/natrix/hardware-configuration.nix
          ];
        };
      };
    };
}
