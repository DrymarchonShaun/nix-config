{ config, configVars, pkgs, ... }: {
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    package = pkgs.libvirt;
    extraConfig = ''
      user="${configVars.username}"
    '';

    # Don't start any VMs automatically on boot.
    onBoot = "ignore";
    # Stop all running VMs on shutdown.
    onShutdown = "shutdown";

    qemu = {
      package = pkgs.qemu_kvm.overrideAttrs {
        pipewireSupport = true;
        patches = [
          ./qemu-anti-detection.patch
        ];
      };
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMFFull.override {
            secureBoot = true;
            tpmSupport = true;
            edk2 = pkgs.edk2.overrideAttrs (attrs: {
              patches = attrs.patches ++ [ ./edk2-to-am.patch ];
            });
          }).fd
        ];
      };
    };
  };

  users.users.${configVars.username}.extraGroups = [
    "qemu-libvirtd"
    "libvirtd"
    "disk"
  ];
  boot = {
    kernelPatches = [
      #  {
      #    name = "rdtsc";
      #    patch = ./rdtsc.patch;
      #  }
    ];
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      # "vfio_virqfd"
    ];
    kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    kernelParams = [ "amd_iommu=on" "amd_iommu=pt" "kvm.ignore_msrs=1" ];
    extraModprobeConfig = "options vfio-pci ids=10de:2182,10de:1aeb,10de:1aec,10de:1aed";
  };
}
