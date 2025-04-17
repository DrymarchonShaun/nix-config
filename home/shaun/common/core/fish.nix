{ pkgs, ... }:
{

  programs.fish = {
    enable = true;
    generateCompletions = true;

    functions = {
      ns = {
        body = ''
          for arg in $argv
              set -a args "nixpkgs#"$arg
          end
          nix shell $args
        '';
        wraps = "nix shell nixpkgs#";
      };
      fish_user_key_bindings = ''

      '';
    };

    plugins = [
      # { name = "fzf-fish"; inherit (pkgs.fishPlugins.fzf-fish) src; }
      {
        name = "sponge";
        inherit (pkgs.fishPlugins.sponge) src;
      }
      {
        name = "foreign-env";
        inherit (pkgs.fishPlugins.foreign-env) src;
      }
      {
        name = "done";
        inherit (pkgs.fishPlugins.done) src;
      }
    ];
  };
  home.packages = [
    pkgs.libnotify
  ];
}
