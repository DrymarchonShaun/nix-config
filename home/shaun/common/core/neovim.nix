{
  inputs,
  pkgs,
  configVars,
  osConfig,
  ...
}:
{
  home.packages = [
    (inputs.nvix.packages.${pkgs.system}.default.extend {
      plugins.lsp.servers.nixd.settings =
        let
          flake = ''builtins.getFlake "/home/${configVars.username}/.src/nix-config"'';
        in
        {
          nixpkgs.expr = "${flake}.inputs.nixpkgs { }";
          formatting.command = [ "nixfmt" ];
          options = {
            nixOptions.expr = ''(${flake}).nixosConfigurations.${osConfig.networking.hostName}.options'';
          };
        };
    })
  ];
}
