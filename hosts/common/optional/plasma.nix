{ pkgs, ... }:
{
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.enable = true;
  programs.dconf.enable = true;
}
