#############################################################
#
#  Natrix - darp8
#  NixOS running on System76 Darter Pro
#
###############################################################

{
  inputs,
  pkgs,
  lib,
  configVars,
  config,
  configLib,
  ...
}:
let
  coraisKernel = pkgs.linux_latest.override { };
  coraisKernelPackages = (pkgs.linuxPackagesFor coraisKernel).extend (
    final: prev: {
      zenergy = final.callPackage ../../pkgs/zenergy { };
    }
  );
in
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
      "hosts/common/optional/virtualization/libvirt" # vm tools
      "hosts/common/optional/services/geoclue.nix"
      "hosts/common/optional/services/greetd.nix"
      "hosts/common/optional/services/bluetooth.nix"
      "hosts/common/optional/services/syncthing.nix"
      "hosts/common/optional/services/ydotool.nix"
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/android.nix" # sudoless adb / fastboot
      "hosts/common/optional/wireshark.nix"
      "hosts/common/optional/unbound.nix"
      "hosts/common/optional/recording.nix"
      "hosts/common/optional/distbuild"
      "hosts/common/optional/vlc.nix"
      "hosts/common/optional/thunar.nix"
      "hosts/common/optional/gaming.nix"

      # Docker Configs
      "hosts/common/optional/virtualization/containers/openbooks.nix"
      "hosts/common/optional/virtualization/containers/foxhole-inventory-report.nix"
      "hosts/common/optional/virtualization/flatpak"

      # Desktop
      "hosts/common/optional/sway.nix" # window manager
      "hosts/common/optional/wooting.nix"

      #################### Users to Create ####################
    ]);

  monitors =
    if configVars.isHeadless then
      [
        {
          name = "HEADLESS-1";
          width = 1920;
          height = 1080;
          refreshRate = 60;
          scale = 1.0;
          x = 0;
          primary = true;
        }
      ]
    else
      [
        {
          name = "DP-1";
          width = 2560;
          height = 1440;
          refreshRate = 165;
          noBar = false;
          scale = 1.0;
          x = 0;
          primary = true;
        }
        {
          name = "DP-2";
          width = 2560;
          height = 1440;
          refreshRate = 165;
          scale = 1.0;
          x = 2560;
        }
      ];

  autoLogin.enable = true;

  boot.kernelPackages = coraisKernelPackages;
  services.gnome.gnome-keyring.enable = true;
  hardware.amdgpu.opencl.enable = true;

  networking = {
    hostName = "corais";
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
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [
      "kvm-amd"
      "zenergy"
    ];
    kernelParams = [ "amdgpu.dcdebugmask=0x10" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
  };

  environment.systemPackages = [ pkgs.metasploit ];

  # VirtualBox settings for Hyprland to display correctly
  # environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  # environment.sessionVariables.WLR_RENDERER_ALLOW_SOFTWARE = "1";

  # Fix to enable VSCode to successfully remote SSH on a client to a NixOS host
  # https://nixos.wiki/wiki/Visual_Studio_Code # Remote_SSH
  programs.nix-ld.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
