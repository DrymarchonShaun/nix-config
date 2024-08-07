{ inputs, pkgs, ... }: {
  home.packages = [ inputs.nvix.packages.${pkgs.system}.default ];
}
