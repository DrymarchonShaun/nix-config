# NOTE: ... is needed because dikso passes diskoFile
{

  lib,
  pkgs,
  configVars,
  ...
}:
{
  disko.devices = {
    disk = {
      primary = {
        type = "disk";
        # Using /dev/disk/by-id/{nvme-eui.*,wwn-0x*} as the device path is more stable than /dev/{nvme*,sd*}
        # For more information see https://wiki.archlinux.org/title/Persistent_block_device_naming#World_Wide_Name
        device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b4909e6e9"; # 1TB
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptprimary";
                passwordFile = "/tmp/disko-password"; # this is populated by bootstrap-nixos.sh
                settings = {
                  allowDiscards = true;
                  # https://github.com/hmajid2301/dotfiles/blob/a0b511c79b11d9b4afe2a5e2b7eedb2af23e288f/systems/x86_64-linux/framework/disks.nix#L36
                  crypttabExtraOpts = [ ];
                };
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # force overwrite
                  subvolumes = {
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "@persist" = {
                      mountpoint = "${configVars.persistFolder}";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "@swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "24G";
                    };
                  };
                };
              };
            };
          };
        };
      };
      extra = {
        type = "disk";
        # Using /dev/disk/by-id/{nvme-eui.*,wwn-0x*} as the device path is more stable than /dev/{nvme*,sd*}
        # For more information see https://wiki.archlinux.org/title/Persistent_block_device_naming#World_Wide_Name
        device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b456ba8d0"; # 500GB
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptextra";
                passwordFile = "/tmp/disko-password"; # this is populated by bootstrap-nixos.sh
                settings = {
                  allowDiscards = true;
                  # https://github.com/hmajid2301/dotfiles/blob/a0b511c79b11d9b4afe2a5e2b7eedb2af23e288f/systems/x86_64-linux/framework/disks.nix#l36
                  crypttabExtraOpts = [ ];
                };
                # Whether to add a boot.initrd.luks.devices entry for the this disk.
                # We only want to unlock cryptroot interactively.
                # You must have a /etc/crypttab entry set up to auto unlock the drive using a key on cryptroot (see /hosts/ghost/default.nix)
                initrdUnlock = if configVars.isMinimal then true else false;

                # subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # force overwrite
                  subvolumes = {
                    "@extra" = {
                      mountpoint = "/run/media/shaun/extra";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

}
