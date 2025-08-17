{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.nixvirt.nixosModules.default
    ./networks.nix
  ];
  users.users.${config.hostSpec.username}.extraGroups = [
    "libvirt"
    "libvirtd"
    "libvirt-qemu"
  ];
  programs.virt-manager.enable = true;
  virtualisation.libvirt.enable = true;
  virtualisation.libvirtd = {
    enable = true;

    # Don't start any VMs automatically on boot.
    onBoot = "ignore";
    # Stop all running VMs on shutdown.
    onShutdown = "shutdown";

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          pkgs.OVMFFull.fd
        ];
      };
    };
  };

  boot = {
    kernelParams = [
      "kvm.ignore_msrs=1"
    ];
  };
}
