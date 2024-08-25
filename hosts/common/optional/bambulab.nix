{ ... }:
{
  # ports???

  networking.firewall = {
    logRefusedPackets = true;
    logRefusedConnections = true;
    extraCommands = ''
      iptables -A nixos-fw -p udp --source 10.0.0.0/24 --sport=56034 -j nixos-fw-accept
      # # SSDP
      #  iptables -A nixos-fw -p udp --source 10.0.0.0/24 --dport 2021 -j nixos-fw-accept
      #  iptables -A nixos-fw -p tcp --source 10.0.0.0/24 --dport 1990 -j nixos-fw-accept
      #  iptables -A nixos-fw -p udp --source 10.0.0.0/24 --dport 2021 -j nixos-fw-accept
      #  iptables -A nixos-fw -p tcp --source 10.0.0.0/24 --dport 1990 -j nixos-fw-accept
      #
      #  # FTP
      #  iptables -A nixos-fw -p tcp --source 10.0.0.0/24 --dport 50000:50100 -j nixos-fw-accept
      #  iptables -A nixos-fw -p udp --source 10.0.0.0/24 --dport 50000:50100 -j nixos-fw-accept
      #  iptables -A nixos-fw -p tcp --source 10.0.0.0/24 --dport 990 -j nixos-fw-accept
      #
      # # Video
      # iptables -A nixos-fw -p tcp --source 10.0.0.0/24 --dport 322 -j nixos-fw-accept
      # iptables -A nixos-fw -p tcp --source 10.0.0.0/24 --dport 6000 -j nixos-fw-accept
    '';
  };
}
