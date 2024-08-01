{
  description = "A Basic Python Playground";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Allows for a cleaner flake.nix
    flake-utils.url = "github:numtide/flake-utils";

    poetry2nix.url = "github:nix-community/poetry2nix";

  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };
      in {
        packages = let inherit (poetry2nix) mkPoetryApplication;
        in { default = mkPoetryApplication { projectDir = self; }; };

        devShells = let inherit (poetry2nix) mkPoetryEnv;
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              (mkPoetryEnv { projectDir = self; })
              poetry
            ];
          };
        };
      });
}
