# INFO: Modification of home-manager's fish module (https://github.com/nix-community/home-manager/blob/release-24.11/modules/programs/fish.nix)
# Taking advantage of umlx5h's zsh-manpage-completion-generator (https://github.com/umlx5h/zsh-manpage-completion-generator) to instead generate completions for zsh
{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption filter sort;
  cfg = config.programs.zsh;
in
{
  options = {
    programs.zsh = {
      generateCompletions =
        mkEnableOption "the automatic generation of completions based upon home-manager installed man pages"
        // {
          default = false;
        };
      generateSystemCompletions =
        mkEnableOption "also automatically generate completions for packages installed by NixOS"
        // {
          default = false;
        };
    };
  };
  config = lib.mkIf cfg.generateCompletions {
    xdg.dataFile."zsh/home-manager_generated_completions".source =
      let
        completions-generator = pkgs.fetchgit {
          url = "https://github.com/fish-shell/fish-shell.git";
          rev = "62a8b48fd1ee8bf1c07ed5784883943d406c1adb";
          hash = "sha256-Ya+S8n1zj+dnHO+3W2505JQbe+RIKuiZmcN6oJyqwag=";
          sparseCheckout = [
            "share/tools/create_manpage_completions.py"
            "share/tools/deroff.py"
          ];
        };
        # paths later in the list will overwrite those already linked
        destructiveSymlinkJoin =
          args_@{
            name,
            preferLocalBuild ? true,
            allowSubstitutes ? false,
            postBuild ? "",
            ...
          }:
          let
            args =
              removeAttrs args_ [
                "name"
                "postBuild"
              ]
              // {
                # pass the defaults
                inherit preferLocalBuild allowSubstitutes;
              };
          in
          pkgs.runCommand name args ''
            mkdir -p $out
            for i in $paths; do
              if [ -z "$(find $i -prune -empty)" ]; then
                cp -srf $i/* $out
              fi
            done
            ${postBuild}
          '';

        generateCompletions =
          let
            getName =
              attrs: attrs.name or "${attrs.pname or "«pname-missing»"}-${attrs.version or "«version-missing»"}";
          in
          package:
          pkgs.runCommand "${getName package}-zsh-completions"
            {
              srcs =
                [ package ]
                ++ filter (p: p != null) (
                  builtins.map (outName: package.${outName} or null) config.home.extraOutputsToInstall
                );
              nativeBuildInputs = [
                pkgs.python3
                pkgs.zsh-manpage-completion-generator
              ];
              # buildInputs = [ cfg.package ];
              preferLocalBuild = true;
            }
            ''
              mkdir -p $out
              mkdir -p fish_generated_completions
              for src in $srcs; do
                if [ -d $src/share/man ]; then
                  find -L $src/share/man -type f \
                    | xargs python ${completions-generator}/share/tools/create_manpage_completions.py --directory ./fish_generated_completions \
                    > /dev/null
                    zsh-manpage-completion-generator -src ./fish_generated_completions -dst $out > /dev/null
                fi
              done
            '';
      in
      destructiveSymlinkJoin {
        name = "${config.home.username}-zsh-completions";
        paths =
          let
            cmp = (a: b: (a.meta.priority or 0) > (b.meta.priority or 0));
          in
          map generateCompletions (
            sort cmp (
              lib.unique (
                config.home.packages
                ++ lib.optionals cfg.generateSystemCompletions osConfig.environment.systemPackages
              )
            )
          );
      };
    programs.zsh.initExtraBeforeCompInit = ''
      fpath+="${config.xdg.dataHome}/zsh/home-manager_generated_completions"
    '';
  };
}
