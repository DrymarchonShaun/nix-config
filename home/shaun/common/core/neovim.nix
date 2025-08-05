{
  inputs,
  pkgs,
  config,
  ...
}:
let
  # TODO(nvim): janky, hardcoded path to nix config rep - find a better way to do this that doesn't require a hardcoded path.
  flakeRoot = "git+file://${config.hostSpec.home}/.src/nix/nix-config?ref=stable";
in
{
  home.packages = [
    (inputs.nvix.packages.${pkgs.system}.default.extend {
      plugins.lsp.servers.nixd = {
        settings = {
          nixpkgs.expr = ''import (builtins.getFlake "${flakeRoot}").inputs.nixpkgs {}'';
          options = {
            nixos.expr = ''
              (builtins.getFlake "${flakeRoot}").nixosConfigurations.${config.hostSpec.hostName}.options
            '';
            home_manager.expr = ''
              (builtins.getFlake "${flakeRoot}").nixosConfigurations.${config.hostSpec.hostName}.options.home-manager.users.value.${config.hostSpec.username}
            '';
            nixvim.expr = ''
              (builtins.getFlake "${flakeRoot}").inputs.nvix.packages.${pkgs.system}.default.options
            '';
          };
        };
      };
      lsp.servers.sqf_analyzer = {
        enable = true;
        package = pkgs.sqf-analyzer-lsp;
        settings = {
          cmd = [ "sqf-analyzer-server" ];
          filetypes = [
            "sqf"
            "ext"
          ];
        };
      };
    })
  ];
}
