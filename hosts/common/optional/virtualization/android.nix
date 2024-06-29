{ pkgs, ... }: {
  virtualisation.anbox = {
    enable = true;
    image = pkgs.anbox.image;
  };
}