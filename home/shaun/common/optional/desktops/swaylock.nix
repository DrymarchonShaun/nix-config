{ pkgs, lib, ... }:
{

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      bs-hl-color = lib.mkForce "#8aadf4";
      caps-lock-bs-hl-color = lib.mkForce "#8aadf4";
      caps-lock-key-hl-color = lib.mkForce "#8aadf4";
      clock = true;
      datestr = "%b %d, %G";
      font = "Roboto Mono";
      font-size = 45;
      ignore-empty-password = true;
      image = "${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin-blurred.png";
      indicator = true;
      indicator-caps-lock = true;
      indicator-radius = 170;
      indicator-thickness = 15;
      inside-caps-lock-color = lib.mkForce "#24273a";
      inside-clear-color = lib.mkForce "#24273a";
      inside-color = lib.mkForce "#24273a";
      inside-ver-color = lib.mkForce "#24273a";
      inside-wrong-color = lib.mkForce "#24273a";
      key-hl-color = lib.mkForce "#8aadf4";
      layout-bg-color = lib.mkForce "#1e1e2e";
      layout-text-color = lib.mkForce "#8aadf4";
      line-caps-lock-color = lib.mkForce "#00000000";
      line-clear-color = lib.mkForce "#00000000";
      line-color = lib.mkForce "#00000000";
      line-ver-color = lib.mkForce "#00000000";
      line-wrong-color = lib.mkForce "#00000000";
      ring-caps-lock-color = lib.mkForce "#1e2030";
      ring-clear-color = lib.mkForce "#1e2030";
      ring-color = lib.mkForce "#1e2030";
      ring-ver-color = lib.mkForce "#a6da95";
      ring-wrong-color = lib.mkForce "#ed8796";
      scaling = "fill";
      separator-color = lib.mkForce "#00000000";
      show-failed-attempts = true;
      text-caps-lock-color = lib.mkForce "#8aadf4";
      text-clear-color = lib.mkForce "#8aadf4";
      text-color = lib.mkForce "#8aadf4";
      text-ver-color = lib.mkForce "#8aadf4";
      text-wrong-color = lib.mkForce "#8aadf4";
      timestr = "%I:%M %p";
    };
  };
}
