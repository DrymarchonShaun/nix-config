#############################################################
#
#  Natrix - darp8
#  NixOS running on System76 Darter Pro
#
###############################################################

{
  inputs,
  lib,
  pkgs,
  config,
  configLib,
  ...
}:
let
  natrixKernel = pkgs.linux_latest.override { };
  natrixKernelPackages = (pkgs.linuxPackagesFor natrixKernel).extend (
    final: prev: {
      system76 = (pkgs.linuxPackagesFor natrixKernel).system76.overrideAttrs (attrs: {
        version = "1.0.13-unstable";
        src = attrs.src // {
          rev = "341bcde2d280e384261019baec1496acf5d04d95";
          sha256 = "";
        };
        patches = [
          (pkgs.fetchpatch {
            name = "fix-linux-6_11-build.patch";
            url = "https://github.com/pop-os/system76-dkms/pull/68.patch";
            hash = "sha256-kWili/IGIGx4PblfcMUVx821UA2oeZzZngcEba/LNw8=";
          })
        ];
      });
    }
  );
in
{
  imports =
    [
      #################### Every Host Needs This ####################
      ./hardware-configuration.nix

      #################### Hardware Modules ####################
      inputs.hardware.nixosModules.common-cpu-intel
      # inputs.hardware.nixosModules.common-gpu-intel
      inputs.hardware.nixosModules.common-pc-ssd

      #################### Disk Layout ####################
      inputs.disko.nixosModules.disko
      (configLib.relativeToRoot "hosts/common/disks/natrix.nix")
    ]
    ++ (map configLib.relativeToRoot [
      #################### Required Configs ####################
      "hosts/common/core"

      "hosts/common/optional/services/avahi.nix"
      "hosts/common/optional/services/openssh.nix"
      "hosts/common/optional/services/geoclue.nix"
      "hosts/common/optional/services/bluetooth.nix"
      "hosts/common/optional/services/syncthing.nix"
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/wireshark.nix"
      "hosts/common/optional/unbound.nix"
      "hosts/common/optional/distbuild"
      "hosts/common/optional/recording.nix"
      "hosts/common/optional/vlc.nix"
      "hosts/common/optional/thunar.nix"
      "hosts/common/optional/gaming.nix"

      # Virtualization
      "hosts/common/optional/virtualization/libvirt"
      # "hosts/common/optional/virtualization/libvirt/windows.nix"
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

  boot.kernelPackages = natrixKernelPackages;

  hardware = {
    system76.enableAll = true;
    system76.power-daemon.enable = lib.mkForce false;
  };

  services = {
    fwupd.enable = true;
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 30;
        CPU_BOOST_ON_AC = 0;
        CPU_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;
        # PCIE_ASPM_ON_BAT = "powersupersave";
        # PCIE_ASPM_ON_AC = "powersupersave";
        DISK_DEVICES = "nvme0n1 nvme1n1";
        RUNTIME_PM_ON_AC = "auto";
        SOUND_POWER_SAVE_ON_AC = 0;
        USB_EXCLUDE_BTUSB = 1;
        USB_EXCLUDE_PHONE = 1;
      };
    };
  };

  # needed unlock LUKS on secondary drives
  # use partition UUID
  # https://wiki.nixos.org/wiki/Full_Disk_Encryption#Unlocking_secondary_drives
  environment.etc = {
    crypttab = {
      text = ''
        cryptextra /dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b456ba8d0-part1 /.luks-secondary-unlock.key luks
      '';
    };
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
  '';

  services.gnome.gnome-keyring.enable = true;

  networking = {
    hostName = "natrix";
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  boot = {
    kernelParams = [
      "acpi_backlight=native"
      "intel_iommu=on"
      "iommu=pt"
      #"i915.force_probe=!46a6"
      #"xe.force_probe=46a6"
      #"xe.max_vfs=7"
    ];
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
  system.stateVersion = "24.05";
}
