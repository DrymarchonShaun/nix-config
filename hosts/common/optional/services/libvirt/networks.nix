{ inputs, ... }:
{
  virtualisation.libvirt.connections."qemu:///system".networks = [
    {
      definition = inputs.NixVirt.lib.network.writeXML {
        name = "default";
        uuid = "3c1c8fe2-4fe1-487c-bdce-f700f671850f";
        forward = {
          mode = "nat";
          nat = {
            port = {
              start = 1024;
              end = 65535;
            };
          };
        };
        bridge = {
          name = "virtbr0";
        };
        mac = {
          address = "52:54:00:8b:ef:77";
        };
        ip = {
          address = "192.168.122.1";
          netmask = "255.255.255.0";
          dhcp = {
            range = {
              start = "192.168.122.2";
              end = "192.168.122.254";
            };
          };
        };
      };
      active = true;
    }
  ];
}
