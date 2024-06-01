{ pkgs, ... }: {

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      # bs-hl-color = "#8aadf4";
      # caps-lock-bs-hl-color = "#8aadf4";
      # caps-lock-key-hl-color = "#8aadf4";
      clock = true;
      datestr = "%b %d, %G";
      font = "Roboto";
      font-size = 45;
      ignore-empty-password = true;
      image = "${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin-blurred.png";
      indicator = true;
      indicator-caps-lock = true;
      indicator-radius = 170;
      indicator-thickness = 15;
      #  inside-caps-lock-color = "#24273a";
      #  inside-clear-color = "#24273a";
      #  inside-color = "#24273a";
      #  inside-ver-color = "#24273a";
      #  inside-wrong-color = "#24273a";
      #  key-hl-color = "#8aadf4";
      #  layout-bg-color = "#1e1e2e";
      #  layout-text-color = "#8aadf4";
      #  line-caps-lock-color = "#00000000";
      #  line-clear-color = "#00000000";
      #  line-color = "#00000000";
      #  line-ver-color = "#00000000";
      #  line-wrong-color = "#00000000";
      #  ring-caps-lock-color = "#1e2030";
      #  ring-clear-color = "#1e2030";
      #  ring-color = "#1e2030";
      #  ring-ver-color = "#a6da95";
      #  ring-wrong-color = "#ed8796";
      scaling = "fill";
      #  separator-color = "#00000000";
      show-failed-attempts = true;
      #  text-caps-lock-color = "#8aadf4";
      #  text-clear-color = "#8aadf4";
      #  text-color = "#8aadf4";
      #  text-ver-color = "#8aadf4";
      #  text-wrong-color = "#8aadf4";
      timestr = "%I:%M %p";
    };
  };
}
