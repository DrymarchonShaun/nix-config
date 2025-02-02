{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  sopsFolder = builtins.toString inputs.nix-secrets + "/sops";
in
{

  users.users.${config.hostSpec.username}.extraGroups = [
    "wireshark"
  ];

  sops = {
    secrets."passwords/networks/DebuggingAP_psk" = {
      sopsFile = "${sopsFolder}/shared.yaml";
    };
    templates = {
      "create_ap.conf" = {
        content = ''
          INTERNET_IFACE=eth0
          WIFI_IFACE=wlan0
          FREQ_BAND=2.4
          MAC_FILTER=1
          MAC_FILTER_ACCEPT=${
            pkgs.writeTextFile {
              name = "hostapd.accept";
              text = lib.concatStringsSep "\n" config.hostSpec.networking.mac-addresses;
            }
          }
          SSID=DebuggingAP
          PASSPHRASE=${config.sops.placeholder."passwords/networks/DebuggingAP_psk"}
        '';
      };
    };
  };
  services.create_ap = {
    enable = true;
    configPath = config.sops.templates."create_ap.conf".path;
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
}
