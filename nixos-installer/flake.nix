{
  description = "Minimal NixOS configuration for bootstrapping systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    disko.url = "github:nix-community/disko"; # Declarative partitioning and formatting
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
        name: disk: withSwap: swapSize:
        (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = minimalSpecialArgs;
          modules = [
            inputs.disko.nixosModules.disko
            ../hosts/common/disks/standard-disk-config.nix
            {
              _module.args = {
                inherit disk withSwap swapSize;
              };
            }
            ./minimal-configuration.nix
            ../hosts/nixos/${name}/hardware-configuration.nix

            { networking.hostName = name; }
          ];
        });
    in
    {
      nixosConfigurations = {
        # host = newConfig "name" disk" "withSwap" "swapSize"
        # Swap size is in GiB
        grief = newConfig "grief" "/dev/vda" false "0";
        guppy = newConfig "guppy" "/dev/vda" false "0";

        #TODO:(gusto) uncomment when gusto gets moved to disko, until then flake check errors on this because gustos current hw config doesn't match the disko spec that installer uses
        #gusto = newConfig "gusto" "/dev/sda" true "8";

        ghost = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = minimalSpecialArgs;
          modules = [
            inputs.disko.nixosModules.disko
            ../hosts/common/disks/ghost.nix
            ./minimal-configuration.nix
            { networking.hostName = "ghost"; }
            ../hosts/nixos/ghost/hardware-configuration.nix
          ];
        };

        corais = newConfig "corais" "/dev/nvme0n1" true "24";

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
