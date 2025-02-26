{ pkgs, ... }:
{
  services = {
    xembed-sni-proxy = {
      enable = true;
      package = pkgs.xembed-sni-proxy;
    };
    blueman-applet.enable = true;
    gammastep.tray = true;
    network-manager-applet.enable = true;
  };
}
