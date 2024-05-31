# https://github.com/sharkdp/bat
# https://github.com/eth-p/bat-extras

{ pkgs, ... }: {
  programs.bat = {
    enable = true;
    themes = {
      #catppuccin = {
      #  src = pkgs.fetchFromGitHub
      #    {
      #      owner = "catppuccin";
      #      repo = "bat"; # Bat uses sublime syntax for its themes
      #      rev = "main";
      #      sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
      #    };
      #  file = "Catppuccin-macchiato.tmTheme";
      #};
    };
    config = {
      # Show line numbers, Git modifications and file header (but no grid)
      style = "numbers,changes,header";
      #theme = "catppuccin";
    };
    extraPackages = builtins.attrValues {
      inherit (pkgs.bat-extras)

        batgrep# search through and highlight files using ripgrep
        batdiff# Diff a file against the current git index, or display the diff between to files
        batman; # read manpages using bat as the formatter
    };
  };
}
