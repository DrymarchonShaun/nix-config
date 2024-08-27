{ lib, pkgs, ... }:
{
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  security.wrappers.dumpcap.capabilities = lib.mkForce "cap_net_raw,cap_net_admin,cap_dac_override+eip";
  services.udev.extraRules = ''
    SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
  '';
}
