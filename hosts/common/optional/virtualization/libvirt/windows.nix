{ inputs, pkgs, ... }:
{
  virtualisation.libvirt.connections."qemu:///system".domains = [
    {
      definition = inputs.nixvirt.lib.domain.writeXML {
        type = "kvm";

        name = "Windows 11 (corais)";
        uuid = "78103f8f-6a97-437f-9b98-765e21656584";
        metadata = with inputs.nixvirt.lib.xml; [
          (elem "libosinfo:libosinfo"
            [
              (attr "xmlns:libosinfo" "http://libosinfo.org/xmlns/libvirt/domain/1.0")
            ]
            [ (elem "libosinfo:os" [ (attr "id" "http://microsoft.com/win/11") ] [ ]) ]
          )
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
              value = "78103f8f-6a97-437f-9b98-765e21656584";
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
          count = 20;
          placement = "static";
        };
        memory = {
          count = 16;
          unit = "GiB";
        };
        cpu = {
          mode = "host-passthrough";
          check = "none";
          migratable = false;
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
            cores = 10;
            threads = 2;
          };
        };

        # OS
        os = {
          type = "hvm";
          arch = "x86_64";
          machine = "q35";
          loader = {
            readonly = true;
            type = "pflash";
            # path = "${pkgs.OVMFFull.fd}/FV/OVMF_CODE.fd";
            path = "/run/libvirt/nix-ovmf/OVMF_CODE.ms.fd";
          };
          nvram = {
            # template = "${pkgs.OVMFFull.fd}/FV/OVMF_VARS.fd";
            template = "/run/libvirt/nix-ovmf/OVMF_VARS.ms.fd";
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
              type = "block";
              device = "disk";
              driver = {
                name = "qemu";
                type = "raw";
                cache = "none";
                io = "native";
                discard = "unmap";
              };
              source = {
                dev = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_500GB_S598NG0MA08105W";
              };
              target = {
                dev = "sdd";
                bus = "sata";
              };
              serial = "S598NG0MA08105W";
              boot = {
                order = 1;
              };
              alias = {
                name = "ua-winboot";
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
          };

          input = [
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
          };
          audio = {
            id = 1;
            type = "pipewire";
            runtimeDir = "/run/user/1000";
          };

          tpm = {
            model = "tpm-crb";
            backend = {
              type = "emulator";
              version = "2.0";
            };
          };

          graphics = {
            type = "spice";
            autoport = true;
            listen = {
              type = "address";
              address = "127.0.0.1";
            };
            image = {
              compression = false;
            };
          };

          video = {
            model = {
              type = "qxl";
              heads = 1;
              primary = true;
              ram = 65536;
              vgamem = 16384;
              vram = 65536;
            };
          };

          watchdog = {
            model = "itco";
            action = "reset";
          };
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
