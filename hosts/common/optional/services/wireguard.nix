{ inputs, config, ... }:
let
  wgPort = config.hostSpec.networking.ports.udp.wireguard;
  sopsFolder = (builtins.toString inputs.nix-secrets) + "/sops";
in
{
  sops = {
    secrets."keys/wireguard" = {
      sopsFile = "${sopsFolder}/shared.yaml";
    };
    templates."wireguard.env" = {
      mode = "0400";
      content = ''
        Wireguard_Private_Key=${config.sops.placeholder."keys/wireguard"}
      '';
    };
  };

  networking = {
    firewall = {
      allowedUDPPorts = [ wgPort ];
      # if packets are still dropped, they will show up in dmesg
      logReversePathDrops = true;
      # wireguard trips rpfilter up
      extraCommands = ''
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport ${builtins.toString wgPort} -j RETURN
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport ${builtins.toString wgPort} -j RETURN
      '';
      extraStopCommands = ''
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport ${builtins.toString wgPort} -j RETURN || true
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport ${builtins.toString wgPort} -j RETURN || true
      '';
    };

    networkmanager.ensureProfiles = {
      environmentFiles = [
        config.sops.templates."wireguard.env".path
      ];

      profiles = {
        "Home" = {
          connection = {
            autoconnect = "false";
            id = "Home";
            interface-name = "wg0";
            type = "wireguard";
          };
          ipv4 = {
            address1 = "10.0.0.2/24";
            dns = "10.0.0.1;64.6.64.6;";
            dns-search = "~";
            method = "manual";
          };

          ipv6 = {
            addr-gen-mode = "default";
            address1 = "fd00:db8:0:abc::2/64";
            dns = "fd00:db8:0:abc::1";
            dns-search = "~";
            method = "manual";
          };

          wireguard = {
            mtu = 1420;
            private-key = "$Wireguard_Private_Key";
          };
          "wireguard-peer.6f+8m02TqhI54UuxZkpr9NTSrfixbHmk+XNYr+y/Kl4=" = {
            allowed-ips = "0.0.0.0/0;::/0;";
            endpoint = "${inputs.nix-secrets.homeDomain}:${toString wgPort}";
            persistent-keepalive = "25";
          };
        };
      };
    };
  };
}
