{ inputs, config, configVars, pkgs, ... }: {
  imports = [
    inputs.NixVirt.nixosModules.default
    ./windows.nix
    ./networks.nix
  ];
  programs.virt-manager.enable = true;
  virtualisation.libvirt = {
    enable = true;
  };
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
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          pkgs.OVMFFull.fd
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
