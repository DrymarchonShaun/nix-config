{ ... }:
{
  programs.hyprland = {
    enable = true;
  };

  # required for hyprpanel to detect battery
  services.upower.enable = true;

  environment.systemPackages = [
  ];
}
