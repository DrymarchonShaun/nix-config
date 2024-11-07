{
  description = "A Basic Rust Flake";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # allows for a cleaner flake.nix
    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
      ...
    }@inputs:
    flake-utils.lib.eachdefaultsystem (
      system:
      let
        pkgs = (nixpkgs.legacyPackages.${system}.extend rust-overlay.overlays.default);
      in
      {
        packages = {
          default = self.devShells.default;
        };

        devShells = {
          default = pkgs.mkShell {
            packages = [
              pkgs.rust-bin.stable.latest.default
            ];
          };
        };
      }
    );
}
