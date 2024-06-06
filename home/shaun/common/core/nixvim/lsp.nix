{ inputs, pkgs, lib, ... }:
{
  programs.nixvim.plugins = {
    nix.enable = true;
    lsp = {
      enable = true;
      servers = {
        nil-ls = {
          enable = true;
          package = inputs.nil.packages.${pkgs.system}.default;
          extraOptions = {
            nix = {
              maxMemoryMB = 0;
              flake = {
                autoArchive = lib.mkDefault true;
                autoEvalInputs = lib.mkDefault true;
                nixpkgsInputName = "nixpkgs";
              };
            };
          };
        };
      };
    };
    none-ls = {
      enable = true;
      enableLspFormat = true;
      sources = {
        code_actions.statix.enable = true;
        diagnostics.statix.enable = true;
        formatting.nixpkgs_fmt.enable = true;
      };
    };
    lsp-format.enable = true;
  };
}
