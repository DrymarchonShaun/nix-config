#############################################################
#
#  Natrix - darp8
#  NixOS running on System76 Darter Pro
#
###############################################################

{
  inputs,
  pkgs,
  configLib,
  ...
}:
{
  imports =
    [
      #################### Every Host Needs This ####################
      ./hardware-configuration.nix

      #################### Hardware Modules ####################
      inputs.hardware.nixosModules.common-cpu-amd
      inputs.hardware.nixosModules.common-gpu-amd
      inputs.hardware.nixosModules.common-pc-ssd
      #################### Disk Layout ####################
      inputs.disko.nixosModules.disko
      (configLib.relativeToRoot "hosts/common/disks/standard-disk-config.nix")
      {
        _module.args = {
          disk = "/dev/nvme0n1";
          withSwap = true;
          swapSize = "24";
        };
      }
    ]
    ++ (map configLib.relativeToRoot [
      #################### Required Configs ####################
      "hosts/common/core"
      #################### Host-specific Optional Configs ####################
      "hosts/common/optional/services/avahi.nix"
      "hosts/common/optional/services/openssh.nix"
      "hosts/common/optional/libvirt.nix" # vm tools
      "hosts/common/optional/services/geoclue.nix"
      "hosts/common/optional/services/bluetooth.nix"
      "hosts/common/optional/services/syncthing.nix"
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/wireshark.nix"
      "hosts/common/optional/unbound.nix"
      "hosts/common/optional/vlc.nix"
      "hosts/common/optional/thunar.nix"
      "hosts/common/optional/gaming.nix"

      # Docker Configs
      "hosts/common/optional/virtualization/docker"
      "hosts/common/optional/virtualization/docker/openbooks.nix"

      # Desktop
      # "hosts/common/optional/hyprland.nix" # window manager
      "hosts/common/optional/sway.nix" # window manager
      # "hosts/common/optional/plasma.nix" # desktop environment
      "hosts/common/optional/wooting.nix"

      #################### Users to Create ####################
    ]);

  services.gnome.gnome-keyring.enable = true;
  # TODO enable and move to greetd area? may need authentication dir or something?
  # services.pam.services.greetd.enableGnomeKeyring = true;
  hardware.amdgpu.opencl.enable = true;

  networking = {
    hostName = "corais";
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  fileSystems."/run/media/shaun/HDD" = {
    device = "/dev/disk/by-label/HDD";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "nosuid"
      "nodev"
      "nofail"
      "noatime"
    ];
  };

  boot = {
    kernelModules = [
      "kvm-amd"
      "zenergy"
    ];
    kernelParams = [ "amdgpu.dcdebugmask=0x10" ];
    extraModulePackages = [ (config.boot.kernelPackages.callPackage ../../pkgs/zenergy { }) ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
  };

  # VirtualBox settings for Hyprland to display correctly
  # environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  # environment.sessionVariables.WLR_RENDERER_ALLOW_SOFTWARE = "1";

  # Fix to enable VSCode to successfully remote SSH on a client to a NixOS host
  # https://nixos.wiki/wiki/Visual_Studio_Code # Remote_SSH
  programs.nix-ld.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
