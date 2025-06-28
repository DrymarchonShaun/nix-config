#############################################################
#
#  getula - Server
#  NixOS running on i9-9900, Radeon RX 5700 XT, 16GB RAM
#
###############################################################

{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  getulaKernel = pkgs.linux_latest.override { };
  getulaKernelPackages = (pkgs.linuxPackagesFor getulaKernel).extend (
    final: prev: {

    }
  );
in
{
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    #
    # ========== Disk Layout ==========
    #
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/btrfs-impermanence-disk.nix")
    {
      _module.args = {
        disk = "/dev/disk/by-id/wwn-0x50026b738033a0f0";
        withSwap = true;
        swapSize = "16";
      };
    }
    #
    # ========== Misc Inputs ==========
    #
    inputs.stylix.nixosModules.stylix

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Optional Configs ==========
      #
      "hosts/common/core/services/auto-upgrade.nix" # auto upgrade as this is a server
      "hosts/common/optional/libvirt.nix" # vm tools
      "hosts/common/optional/nvtop.nix" # GPU monitor (not available in home-manager)
      "hosts/common/optional/plymouth.nix" # fancy boot screen
      "hosts/common/optional/services/avahi.nix" # host discovery
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/services/polkit.nix" # allow remote SSH access
      "hosts/common/optional/services/syncthing.nix" # syncthing
      "hosts/common/optional/unbound.nix" # dns server
      "hosts/common/optional/virtualization/containers/openbooks.nix"

      #
      # ========== getula Specific ==========
      #
      "hosts/common/optional/minecraft" # declarative minecraft server
    ])

  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "getula";
    isServer = true;
    useYubikey = lib.mkForce false;
    persistFolder = "/persist"; # added for "completion" because of the disko spec that was used even though impermanence isn't actually enabled here yet.
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  #  services.gnome.gnome-keyring.enable = true;

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  boot = {
    kernelPackages = getulaKernelPackages;
    kernelModules = [
    ];
    kernelParams = [ ];
  };
  boot.loader = {
    systemd-boot = {
      enable = true;
      # When using plymouth, initrd can expand by a lot each time, so limit how many we keep around
      configurationLimit = lib.mkDefault 10;
    };
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  boot.initrd = {
    kernelModules = [ "amdgpu" ];
    systemd.enable = true;
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
