{ pkgs, ... }:
let
  vscode-wayland = pkgs.vscode.overrideAttrs (
    old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/code \
          --add-flags "--enable-features=UseOzonePlatform" \
          --add-flags "--ozone-platform=wayland"
      '';
    }
  );
in
{
  programs.vscode = {
    enable = true;
    package = vscode-wayland;
    extensions = with pkgs.vscode-marketplace; [
      # Nix
      mkhl.direnv
      jnoortheen.nix-ide

      # Theme
      (pkgs.catppuccin-vsc.override {
        accent = "blue";
      })

      # Misc
      edwinkofler.vscode-hyperupcall-pack-core
      edwinkofler.vscode-hyperupcall-pack-python
      edwinkofler.vscode-hyperupcall-pack-rust
      edwinkofler.vscode-hyperupcall-pack-unix
      #oderwat.indent-rainbow
      #christian-kohler.path-intellisense
      #spywhere.guides
      #streetsidesoftware.code-spell-checker
      #bierner.docs-view
      #tamasfe.even-better-toml
      #redhat.vscode-yaml
      #aaron-bond.better-comments
      #adpyke.codesnap
      #gruntfuggly.todo-tree
      #editorconfig.editorconfig
      #redhat.vscode-xml

      # python
      #ms-python.python
      #wholroyd.jinja
      #batisteo.vscode-django
      #kevinrose.vsc-python-indent
      #mgesbert.python-path
      #donjayamanne.python-environment-manager
      #charliermarsh.ruff
      #ms-toolsai.jupyter
    ];
  };
}
