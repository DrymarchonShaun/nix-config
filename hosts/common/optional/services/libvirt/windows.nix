{ inputs, pkgs, ... }: {
  virtualisation.libvirt.connections."qemu:///system".domains = [
    {
      definition = inputs.NixVirt.lib.domain.writeXML
        {
          type = "kvm";

          name = "win11";
          uuid = "78103f8f-6a97-437f-9b98-765e21656584";
          metadata = with inputs.NixVirt.lib.xml;
            [
              (elem "libosinfo:libosinfo" [ (attr "xmlns:libosinfo" "http://libosinfo.org/xmlns/libvirt/domain/1.0") ]
                [
                  (elem "libosinfo:os" [ (attr "id" "http://microsoft.com/win/11") ] [ ])
                ])
            ];

          sysinfo = {
            type = "smbios";
            bios.entry = [
              { name = "vendor"; value = "American Megatrends Inc."; }
              { name = "version"; value = "4602"; }
              { name = "date"; value = "02/23/2023"; }
            ];
            system.entry = [
              { name = "manufacturer"; value = "ASUSTeK COMPUTER INC."; }
              { name = "product"; value = "TUF GAMING X570-PLUS (WI-FI)"; }
              { name = "version"; value = "Rev X.0x"; }
              { name = "serial"; value = "Default string"; }
              { name = "uuid"; value = "78103f8f-6a97-437f-9b98-765e21656584"; }
              { name = "sku"; value = "SKU"; }
              { name = "family"; value = "To be filled by O.E.M."; }
            ];
          };

          # CPU and RAM

          vcpu = { count = 14; placement = "static"; };
          memory = { count = 16; unit = "GiB"; };
          cpu = {
            mode = "host-passthrough";
            check = "none";
            migratable = false;
            cache = { mode = "passthrough"; };
            feature = [
              { policy = "require"; name = "hypervisor"; }
              { policy = "disable"; name = "aes"; }
              { policy = "require"; name = "topoext"; }
              { policy = "disable"; name = "x2apic"; }
              { policy = "disable"; name = "svm"; }
              { policy = "require"; name = "amd-stibp"; }
              { policy = "require"; name = "ibpb"; }
              { policy = "require"; name = "stibp"; }
              { policy = "require"; name = "virt-ssbd"; }
              { policy = "require"; name = "amd-ssbd"; }
              { policy = "require"; name = "pdpe1gb"; }
              { policy = "require"; name = "tsc-deadline"; }
              { policy = "require"; name = "tsc_adjust"; }
              { policy = "require"; name = "arch-capabilities"; }
              { policy = "require"; name = "rdctl-no"; }
              { policy = "require"; name = "skip-l1dfl-vmentry"; }
              { policy = "require"; name = "mds-no"; }
              { policy = "require"; name = "pschange-mc-no"; }
              { policy = "require"; name = "invtsc"; }
              { policy = "require"; name = "cmp_legacy"; }
              { policy = "require"; name = "xsaves"; }
              { policy = "require"; name = "perfctr_core"; }
              { policy = "require"; name = "clzero"; }
              { policy = "require"; name = "xsaveerptr"; }
            ];
            topology = {
              sockets = 1;
              dies = 1;
              cores = 7;
              threads = 2;
            };
          };

          # OS
          os = {
            type = "hvm";
            arch = "x86_64";
            machine = "pc-q35-8.2";
            loader = {
              readonly = true;
              type = "pflash";
              # path = "${pkgs.OVMFFull.fd}/FV/OVMF_CODE.fd";
              path = "/run/libvirt/nix-ovmf/OVMF_CODE.fd";
            };
            nvram = {
              # template = "${pkgs.OVMFFull.fd}/FV/OVMF_VARS.fd";
              template = "/run/libvirt/nix-ovmf/OVMF_VARS.fd";
              path = "/var/lib/libvirt/qemu/nvram/win11_VARS.fd";
            };
            smbios.mode = "sysinfo";
          };
          features = {
            acpi = { };
            apic = { };
            hyperv = {
              mode = "passthrough";
              relaxed = { state = true; };
              vapic = { state = true; };
              spinlocks = { state = true; retries = 8191; };
              vpindex = { state = true; };
              synic = { state = true; };
              stimer = {
                state = true;
                direct = { state = true; };
              };
              reset = { state = true; };
              vendor_id = { state = true; value = "OriginalAMD"; };
              frequencies = { state = true; };
              reenlightenment = { state = false; };
              tlbflush = { state = true; };
              ipi = { state = true; };
              evmcs = { state = false; };
              avic = { state = true; };
            };
            kvm = {
              hidden = { state = true; };
            };
            vmport = { state = false; };
            smm = { state = true; };
            ioapic = { driver = "kvm"; };
          };

          clock = {
            offset = "timezone";
            timezone = "America/Los_Angeles";
            timer = [
              { name = "rtc"; present = false; tickpolicy = "catchup"; }
              { name = "pit"; tickpolicy = "discard"; }
              { name = "hpet"; present = false; }
              { name = "kvmclock"; present = false; }
              { name = "hypervclock"; present = true; }
              { name = "tsc"; present = true; mode = "native"; }
            ];
          };

          # Power Management
          pm = {
            suspend-to-mem = { enabled = false; };
            suspend-to-disk = { enabled = false; };
          };

          devices = {
            emulator = "${pkgs.qemu_kvm}/bin/qemu-system-x86_64";

            disk = [
              {
                type = "block";
                device = "disk";
                driver = { name = "qemu"; type = "raw"; cache = "none"; io = "native"; discard = "unmap"; };
                source = { dev = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_500GB_S598NG0MA08105W"; };
                target = { dev = "sdd"; bus = "sata"; };
                serial = "S598NG0MA08105W";
                boot = { order = 1; };
                alias = { name = "ua-winboot"; };
                address = { type = "drive"; controller = 0; bus = 0; target = 0; unit = 3; };
              }
            ];

            interface = {
              type = "network";
              mac = { address = "52:54:00:5c:78:25"; };
              source = { network = "default"; };
              model = { type = "e1000e"; };
              address = { type = "pci"; domain = 0; bus = 5; slot = 0; function = 0; };
            };

            input = [
              {
                type = "evdev";
                source =
                  {
                    dev = "/dev/input/by-id/usb-SteelSeries_SteelSeries_Rival_650_Wireless_000000000000-if01-event-mouse";
                  };
              }
              {
                type = "evdev";
                source = { dev = "/dev/input/by-id/usb-Wooting_WootingTwoHE_A02B2130W041H00501-if03-event-kbd"; grab = "all"; grabToggle = "ctrl-ctrl"; repeat = true; };
              }
              {
                type = "mouse";
                bus = "ps2";
              }
              {
                type = "keyboard";
                bus = "ps2";
              }
            ];

            sound = {
              model = "ich9";
              codec = {
                type = "micro";
              };
              audio = { id = 1; };
              address = {
                type = "pci";
                domain = 0;
                bus = 0;
                slot = 27;
                function = 0;
              };
            };
            audio = {
              id = 1;
              type = "pulseaudio";
              serverName = "/run/user/1000/pulse/native";
            };


            tpm = {
              model = "tpm-crb";
              backend = {
                type = "emulator";
                version = "2.0";
              };
            };

            serial = {
              type = "pty";
              target =
                {
                  type = "isa-serial";
                  port = 0;
                  model = { name = "isa-serial"; };
                };
            };

            console = {
              type = "pty";
              target = { type = "serial"; port = 0; };
            };

            # GPU passthrough
            video = {
              model = {
                type = "none";
              };
            };

            hostdev = [
              {
                mode = "subsystem";
                type = "pci";
                managed = true;
                source.address = { domain = 0; bus = 4; slot = 0; function = 0; };
                address = { type = "pci"; domain = 0; bus = 6; slot = 0; function = 0; };
              }
              {
                mode = "subsystem";
                type = "pci";
                managed = true;
                source.address = { domain = 0; bus = 4; slot = 0; function = 1; };
                address = { type = "pci"; domain = 0; bus = 7; slot = 0; function = 0; };
              }
              {
                mode = "subsystem";
                type = "pci";
                managed = true;
                source.address = { domain = 0; bus = 4; slot = 0; function = 2; };
                address = { type = "pci"; domain = 0; bus = 8; slot = 0; function = 0; };
              }
              {
                mode = "subsystem";
                type = "pci";
                managed = true;
                source.address = { domain = 0; bus = 4; slot = 0; function = 3; };
                address = { type = "pci"; domain = 0; bus = 9; slot = 0; function = 0; };
              }
            ];

            watchdog = {
              model = "itco";
              action = "reset";
            };

            controller = [
              {
                type = "usb";
                index = 0;
                model = "qemu-xhci";
                ports = 15;
                address = { type = "pci"; domain = 0; bus = 2; slot = 0; function = 0; };
              }
              { type = "pci"; index = 0; model = "pcie-root"; }
              {
                type = "pci";
                index = 1;
                model = "pcie-root-port";
                target = { chassis = 1; port = 16; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 2; function = 0; multifunction = true; };
              }
              {
                type = "pci";
                index = 2;
                model = "pcie-root-port";
                target = { chassis = 2; port = 17; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 2; function = 1; };
              }
              {
                type = "pci";
                index = 3;
                model = "pcie-root-port";
                target = { chassis = 3; port = 18; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 2; function = 2; };
              }
              {
                type = "pci";
                index = 4;
                model = "pcie-root-port";
                target = { chassis = 4; port = 19; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 2; function = 3; };
              }
              {
                type = "pci";
                index = 5;
                model = "pcie-root-port";
                target = { chassis = 5; port = 20; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 2; function = 4; };
              }
              {
                type = "pci";
                index = 6;
                model = "pcie-root-port";
                target = { chassis = 6; port = 21; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 2; function = 5; };
              }
              {
                type = "pci";
                index = 7;
                model = "pcie-root-port";
                target = { chassis = 7; port = 22; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 2; function = 6; };
              }
              {
                type = "pci";
                index = 8;
                model = "pcie-root-port";
                target = { chassis = 8; port = 23; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 2; function = 7; };
              }
              {
                type = "pci";
                index = 9;
                model = "pcie-root-port";
                target = { chassis = 9; port = 24; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 3; function = 0; multifunction = true; };
              }
              {
                type = "pci";
                index = 10;
                model = "pcie-root-port";
                target = { chassis = 10; port = 25; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 3; function = 1; };
              }
              {
                type = "pci";
                index = 11;
                model = "pcie-root-port";
                target = { chassis = 11; port = 26; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 3; function = 2; };
              }
              {
                type = "pci";
                index = 12;
                model = "pcie-root-port";
                target = { chassis = 12; port = 27; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 3; function = 3; };
              }
              {
                type = "pci";
                index = 13;
                model = "pcie-root-port";
                target = { chassis = 13; port = 28; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 3; function = 4; };
              }
              {
                type = "pci";
                index = 14;
                model = "pcie-root-port";
                target = { chassis = 14; port = 29; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 3; function = 5; };
              }
              {
                type = "pci";
                index = 15;
                model = "pcie-root-port";
                target = { chassis = 15; port = 30; };
                address = { type = "pci"; domain = 0; bus = 0; slot = 3; function = 6; };
              }
              {
                type = "pci";
                index = 16;
                model = "pcie-to-pci-bridge";
                address = { type = "pci"; domain = 0; bus = 1; slot = 0; function = 0; };
              }
              {
                type = "sata";
                index = 0;
                address = { type = "pci"; domain = 0; bus = 0; slot = 31; function = 2; };
              }
              {
                type = "virtio-serial";
                index = 0;
                address = { type = "pci"; domain = 0; bus = 3; slot = 0; function = 0; };
              }
            ];
          };

          # Anti VM Detection 

          qemu-override = {
            device = {
              alias = "ua-winboot";
              frontend = {
                property = {
                  name = "model";
                  type = "string";
                  value = "Samsung SSD 860 EVO 500GB";
                };
              };
            };
          };
        };
    }
  ];
}
