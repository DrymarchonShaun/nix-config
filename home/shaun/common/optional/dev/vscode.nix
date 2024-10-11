{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-marketplace; [
      # Nix
      mkhl.direnv
      jnoortheen.nix-ide

      # Theme
      (pkgs.catppuccin-vsc.override { accent = "blue"; })
    ];
  };
}
