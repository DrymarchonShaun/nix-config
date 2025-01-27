{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  flakeRoot = lib.custom.relativeToRoot "./.";
in
{
  home.packages = [
    (inputs.nvix.packages.${pkgs.system}.default.extend {
      plugins.lsp.servers.nixd = {
        settings = {
          nixpkgs.expr = ''import (builtins.getFlake "${flakeRoot}").inputs.nixpkgs {}'';
          options = {
            nixos.expr = ''
              let configs = (builtins.getFlake "${flakeRoot}").nixosConfigurations;
              in (builtins.head (builtins.attrValues configs)).options
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
    })
  ];
}
