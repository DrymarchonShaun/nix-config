{ inputs, pkgs, ... }:
{
  virtualisation.libvirt.connections."qemu:///system".domains = [
    {
      definition = inputs.nixvirt.lib.domain.writeXML {
        type = "kvm";

        name = "usb-pcap";
        uuid = "0201cf20-655b-458b-9604-7f24f591662c";
        metadata = with inputs.nixvirt.lib.xml; [
          (elem "libosinfo:libosinfo" [
            (attr "xmlns:libosinfo" "http://libosinfo.org/xmlns/libvirt/domain/1.0")
          ] [ (elem "libosinfo:os" [ (attr "id" "http://microsoft.com/win/11") ] [ ]) ])
        ];

        sysinfo = {
          type = "smbios";
          bios.entry = [
            {
              name = "vendor";
              value = "American Megatrends Inc.";
            }
            {
              name = "version";
              value = "4602";
            }
            {
              name = "date";
              value = "02/23/2023";
            }
          ];
          system.entry = [
            {
              name = "manufacturer";
              value = "ASUSTeK COMPUTER INC.";
            }
            {
              name = "product";
              value = "TUF GAMING X570-PLUS (WI-FI)";
            }
            {
              name = "version";
              value = "Rev X.0x";
            }
            {
              name = "serial";
              value = "Default string";
            }
            {
              name = "uuid";
              value = "0201cf20-655b-458b-9604-7f24f591662c";
            }
            {
              name = "sku";
              value = "SKU";
            }
            {
              name = "family";
              value = "To be filled by O.E.M.";
            }
          ];
        };

        # CPU and RAM

        vcpu = {
          count = 14;
          placement = "static";
        };
        memory = {
          count = 16;
          unit = "GiB";
        };
        cpu = {
          mode = "host-passthrough";
          check = "none";
          migratable = true;
          cache = {
            mode = "passthrough";
          };
          feature = [
            {
              policy = "require";
              name = "hypervisor";
            }
            {
              policy = "disable";
              name = "aes";
            }
            {
              policy = "require";
              name = "topoext";
            }
            {
              policy = "disable";
              name = "x2apic";
            }
            {
              policy = "disable";
              name = "svm";
            }
            {
              policy = "require";
              name = "amd-stibp";
            }
            {
              policy = "require";
              name = "ibpb";
            }
            {
              policy = "require";
              name = "stibp";
            }
            {
              policy = "require";
              name = "virt-ssbd";
            }
            {
              policy = "require";
              name = "amd-ssbd";
            }
            {
              policy = "require";
              name = "pdpe1gb";
            }
            {
              policy = "require";
              name = "tsc-deadline";
            }
            {
              policy = "require";
              name = "tsc_adjust";
            }
            {
              policy = "require";
              name = "arch-capabilities";
            }
            {
              policy = "require";
              name = "rdctl-no";
            }
            {
              policy = "require";
              name = "skip-l1dfl-vmentry";
            }
            {
              policy = "require";
              name = "mds-no";
            }
            {
              policy = "require";
              name = "pschange-mc-no";
            }
            {
              policy = "require";
              name = "invtsc";
            }
            {
              policy = "require";
              name = "cmp_legacy";
            }
            {
              policy = "require";
              name = "xsaves";
            }
            {
              policy = "require";
              name = "perfctr_core";
            }
            {
              policy = "require";
              name = "clzero";
            }
            {
              policy = "require";
              name = "xsaveerptr";
            }
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
            relaxed = {
              state = true;
            };
            vapic = {
              state = true;
            };
            spinlocks = {
              state = true;
              retries = 8191;
            };
            vpindex = {
              state = true;
            };
            synic = {
              state = true;
            };
            stimer = {
              state = true;
              direct = {
                state = true;
              };
            };
            reset = {
              state = true;
            };
            vendor_id = {
              state = true;
              value = "OriginalAMD";
            };
            frequencies = {
              state = true;
            };
            reenlightenment = {
              state = false;
            };
            tlbflush = {
              state = true;
            };
            ipi = {
              state = true;
            };
            evmcs = {
              state = false;
            };
            avic = {
              state = true;
            };
          };
          kvm = {
            hidden = {
              state = true;
            };
          };
          vmport = {
            state = false;
          };
          smm = {
            state = true;
          };
          ioapic = {
            driver = "kvm";
          };
        };

        clock = {
          offset = "timezone";
          timezone = "America/Los_Angeles";
          timer = [
            {
              name = "rtc";
              present = false;
              tickpolicy = "catchup";
            }
            {
              name = "pit";
              tickpolicy = "discard";
            }
            {
              name = "hpet";
              present = false;
            }
            {
              name = "kvmclock";
              present = false;
            }
            {
              name = "hypervclock";
              present = true;
            }
            {
              name = "tsc";
              present = true;
              mode = "native";
            }
          ];
        };

        # Power Management
        pm = {
          suspend-to-mem = {
            enabled = false;
          };
          suspend-to-disk = {
            enabled = false;
          };
        };

        devices = {
          emulator = "${pkgs.qemu_kvm}/bin/qemu-system-x86_64";

          disk = [
            {
              type = "file";
              device = "disk";
              driver = {
                name = "qemu";
                type = "qcow2";
              };
              source = {
                file = "/run/media/shaun/HDD/razer-pcap.qcow2";
              };
              target = {
                dev = "sda";
                bus = "sata";
              };
              address = {
                type = "drive";
                controller = 0;
                bus = 0;
                target = 0;
                unit = 0;
              };
            }
          ];

          interface = {
            type = "network";
            mac = {
              address = "52:54:00:5c:78:25";
            };
            source = {
              network = "default";
            };
            model = {
              type = "e1000e";
            };
            address = {
              type = "pci";
              domain = 0;
              bus = 5;
              slot = 0;
              function = 0;
            };
          };

          input = [
            {
              type = "evdev";
              source = {
                dev = "/dev/input/by-id/usb-Wooting_WootingTwoHE_A02B2130W041H00501-if03-event-kbd";
                grab = "all";
                grabToggle = "ctrl-ctrl";
                repeat = true;
              };
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
            audio = {
              id = 1;
            };
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
            target = {
              type = "isa-serial";
              port = 0;
              model = {
                name = "isa-serial";
              };
            };
          };

          console = {
            type = "pty";
            target = {
              type = "serial";
              port = 0;
            };
          };

          # GPU passthrough
          # video = {
          #   model = {
          #     type = "none";
          #   };
          # };

          hostdev = [
            # Wired
            {
              mode = "subsystem";
              type = "usb";
              managed = true;
              source = {
                vendor.id = "0x1532";
                product.id = "0x00A7";
              };
              address = {
                type = "usb";
                bus = 0;
                port = 1;
              };
            }
            # Wireless
            #   {
            #     mode = "subsystem";
            #     type = "usb";
            #     managed = true;
            #     source = {
            #       vendor.id = "0x1532";
            #       product.id = "0x00A8";
            #     };
            #     address = {
            #       type = "usb";
            #       bus = 0;
            #       port = 2;
            #     };
            #   }
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
              address = {
                type = "pci";
                domain = 0;
                bus = 2;
                slot = 0;
                function = 0;
              };
            }
            {
              type = "sata";
              index = 0;
              address = {
                type = "pci";
                domain = 0;
                bus = 0;
                slot = 31;
                function = 2;
              };
            }
            {
              type = "virtio-serial";
              index = 0;
              address = {
                type = "pci";
                domain = 0;
                bus = 3;
                slot = 0;
                function = 0;
              };
            }
          ];
        };
      };
    }
  ];
}
