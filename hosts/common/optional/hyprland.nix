{ ... }:
{
  programs.hyprland = {
    enable = true;
  };

  # required for hyprpanel to detect battery
  services.upower.enable = true;

  services.xserver = {
    xkb.extraLayouts.real-prog-dvorak = {
      description = "Real Programmer's Dvorak";
      languages = [ "eng" ];
      symbolsFile = ../../../pkgs/common/symbols/real-prog-dvorak;
    };
  };

  environment.systemPackages = [
  ];
}
