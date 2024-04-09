{ pkgs, ... }: {

  # TODO add ttf-font-awesome or font-awesome for waybar
  fontProfiles = {
    enable = true;
    monospace = {
      family = "Roboto Mono";
      package = pkgs.roboto-mono;
    };
    regular = {
      family = "Roboto";
      package = pkgs.roboto;
    };
  };
}
