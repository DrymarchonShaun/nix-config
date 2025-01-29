# git is core no matter what but additional settings may could be added made in optional/foo   eg: development.nix
{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    aliases = {
      stat = "status";
      pr = "!f() { git fetch -fu \${2:-$(git remote |grep ^upstream || echo origin)} refs/pull/$1/head:pr/$1 && git checkout pr/$1; }; f";
      pr-clean = "!git for-each-ref refs/heads/pr/* --format='%(refname)' | while read ref ; do branch=\${ref#refs/heads/} ; git branch -D $branch ; done";
    };

    ignores = [
      ".csvignore"
      # nix
      "*.drv"
      "result"
      # python
      "*.py?"
      "__pycache__/"
      ".venv/"
      # direnv
      ".direnv"
    ];

    extraConfig = {
      core.pager = "delta";
      delta = {
        enable = true;
        features = [
          "side-by-side"
          "line-numbers"
          "hyperlinks"
          "line-numbers"
          "commit-decoration"
        ];
      };

      url =
        { }
        // lib.optionalAttrs (!config.hostSpec.isMinimal) {
          # Only force ssh if it's not minimal
          "ssh://git@github.com" = {
            pushInsteadOf = "https://github.com";
          };
          "ssh://git@codeberg.org" = {
            pushInsteadOf = "https://codeberg.org";
          };
          "ssh://git@gitlab.com" = {
            pushInsteadOf = "https://gitlab.com";
          };
        };

      # pre-emptively ignore mac crap
      core.excludeFiles = builtins.toFile "global-gitignore" ''
        .DS_Store
        .DS_Store?
        ._*
        .Spotlight-V100
        .Trashes
        ehthumbs.db
        Thumbs.db
        node_modules
      '';
      core.attributesfile = builtins.toFile "global-gitattributes" ''
        Cargo.lock -diff
        flake.lock -diff
        *.drawio -diff
        *.svg -diff
        *.json diff=json
        *.bin diff=hex difftool=hex
        *.dat diff=hex difftool=hex
        *aarch64.bin diff=objdump-aarch64 difftool=objdump-aarch64
        *arm.bin diff=objdump-arm difftool=objdump-arm
        *x64.bin diff=objdump-x86_64 difftool=objdump-x64
        *x86.bin diff=objdump-x86 difftool=objdump-x86
      '';
      # Makes single line json diffs easier to read
      diff.json.textconv = "jq --sort-keys .";
    };
  };

}
