# NOTE: ... is needed because dikso passes diskoFile
{
  lib,
  pkgs,
  withSwap ? false,
  swapSize,
  configVars,
  ...
}:
{
  disko.devices = {
    disk = {
      primary = {
        type = "disk";
        device = "/dev/nvme1n1"; # 1tb
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
                name = "cryptroot";
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
                    "@swap" = lib.mkIf withSwap {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "${swapSize}G";
                    };
                  };
                };
              };
            };
          };
        };
      };

      extra = {
        extra = {
          type = "disk";
          device = "/dev/nvme0n1"; # 500gb
          content = {
            type = "gpt";
            partitions = {
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "cryptextra";
                  passwordfile = "/tmp/disko-password"; # this is populated by bootstrap-nixos.sh
                  settings = {
                    allowdiscards = true;
                    # https://github.com/hmajid2301/dotfiles/blob/a0b511c79b11d9b4afe2a5e2b7eedb2af23e288f/systems/x86_64-linux/framework/disks.nix#l36
                    crypttabextraopts = [ "nofail" ];
                  };
                  # whether to add a boot.initrd.luks.devices entry for the this disk.
                  # we only want to unlock cryptroot interactively.
                  # you must have a /etc/crypttab entry set up to auto unlock the drive using a key on cryptroot (see /hosts/ghost/default.nix)
                  initrdunlock = if configvars.isminimal then true else false;

                  # subvolumes must set a mountpoint in order to be mounted,
                  # unless their parent is mounted
                  content = {
                    type = "btrfs";
                    extraargs = [ "-f" ]; # force overwrite
                    subvolumes = {
                      "@extra" = {
                        mountpoint = "/run/media/shaun/extra";
                        mountoptions = [
                          "compress=zstd"
                          "nofail"
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
  };
}
