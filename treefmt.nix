{
  pkgs,
  ...
}:
{
  programs = {
    nixfmt = {
      # format the nix files
      enable = true;
      package = pkgs.nixfmt-rfc-style;
    };

    jsonfmt.enable = true;
    yamlfmt.enable = true;
    toml-sort.enable = true;
    mdformat.enable = true;
    just.enable = true;

  };
  # ignore certain files
  settings.global.excludes = [
    "*.png"
    ".envrc"
    ".direnv/"
  ];
}
