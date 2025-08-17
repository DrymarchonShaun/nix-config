#############################################################
#
#  Corais - Main Desktop
#  NixOS running on Ryzen 7 3700X, Radeon RX 7800 XT, 32GB RAM
#
###############################################################

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  # coraisKernel = pkgs.linux_6_11.override { };
  coraisKernel = pkgs.linux_latest.override { };
  coraisKernelPackages = (pkgs.linuxPackagesFor coraisKernel).extend (
    final: prev: {
      # zenergy = final.callPackage ../../pkgs/zenergy/package.nix { };
    }
  );
in
{
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    # enable wooting udev rules manually to avoid installing wootility
    # (use beta.wootility.io instead)
    { services.udev.packages = [ pkgs.wooting-udev-rules ]; }

    #
    # ========== Disk Layout ==========
    #
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/btrfs-impermanence-disk.nix")
    {
      _module.args = {
        disk = "/dev/disk/by-id/nvme-eui.00253854119048ec";
        withSwap = true;
        swapSize = "24";
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
      "hosts/common/optional/android.nix" # adb / fastboot
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/fonts.nix" # vm tools
      "hosts/common/optional/gaming.nix" # steam, gamescope, gamemode, and related hardware
      "hosts/common/optional/hyprland.nix" # window manager
      "hosts/common/optional/net-analysis.nix" # network analysis tools
      "hosts/common/optional/nvtop.nix" # GPU monitor (not available in home-manager)
      "hosts/common/optional/obsidian.nix" # notes
      "hosts/common/optional/onlykey.nix" # onlykey hardware security key
      "hosts/common/optional/plymouth.nix" # fancy boot screen
      "hosts/common/optional/recording.nix" # obs / virtual camera
      "hosts/common/optional/scanning.nix" # SANE and simple-scan
      "hosts/common/optional/services/avahi.nix" # host discovery
      "hosts/common/optional/services/bluetooth.nix" # bluetooth
      "hosts/common/optional/services/duckdns.nix" # dynamic DNS
      "hosts/common/optional/services/geoclue.nix" # location services
      "hosts/common/optional/services/greetd.nix" # display manager
      "hosts/common/optional/services/lactd.nix"
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/services/polkit.nix" # polkit agent
      "hosts/common/optional/services/printing.nix" # CUPS
      "hosts/common/optional/services/syncthing.nix" # syncthing
      "hosts/common/optional/services/ydotool.nix" # autoclicker / input automation
      "hosts/common/optional/thunar.nix" # file manager
      "hosts/common/optional/unbound.nix" # dns server
      "hosts/common/optional/virtualization/containers/openbooks.nix"
      "hosts/common/optional/virtualization/flatpak" # container subsystem, primarily used for sober (roblox)
      "hosts/common/optional/virtualization/libvirt/default.nix" # container subsystem, primarily used for sober (roblox)
      "hosts/common/optional/virtualization/libvirt/windows.nix" # container subsystem, primarily used for sober (roblox)
      "hosts/common/optional/vlc.nix" # media player
    ])
    #
    # ========== Corais Specific ==========
    #

  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "corais";
    # isServer = true;
    useYubikey = lib.mkForce true;
    hdr = lib.mkForce true;
    persistFolder = "/persist"; # added for "completion" because of the disko spec that was used even though impermanence isn't actually enabled here yet.
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # set custom autologin options. see greetd.nix for details
  autoLogin.enable = lib.mkIf (config.hostSpec.isServer) true;
  autoLogin.username = config.hostSpec.username;
  #
  #  services.gnome.gnome-keyring.enable = true;

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  # FIXME(clamav): something not working. disabled to reduce log spam
  semi-active-av.enable = false;

  services.backup = {
    enable = false;
    borgBackupStartTime = "02:00:00";
    borgServer = "${config.hostSpec.networking.subnets.oops.ip}";
    borgUser = "${config.hostSpec.username}";
    borgPort = "${builtins.toString config.hostSpec.networking.subnets.oops.port}";
    borgBackupPath = "/var/services/homes/${config.hostSpec.username}/backups";
    borgNotifyFrom = "${config.hostSpec.email.notifier}";
    borgNotifyTo = "${config.hostSpec.email.backup}";
  };

  boot = {
    kernelPackages = coraisKernelPackages;
    kernelModules = [
      "kvm-amd"
      "zenergy"
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

  # FIXME: switch to custom disko config on next reinstall
  # TODO: use partition UUID
  # https://wiki.nixos.org/wiki/Full_Disk_Encryption#Unlocking_secondary_drives
  fileSystems."/run/media/shaun/HDD" = {
    device = "/dev/disk/by-id/wwn-0x50014ee2bbdfd424-part1";
    fsType = "ntfs3";
    options = [
      "rw"
      "windows_names"
      "prealloc"
      "uid=1000"
      "nosuid"
      "nodev"
      "nofail"
      "noatime"
    ];
  };
  fileSystems."/run/media/shaun/SSD" = {
    device = "/dev/disk/by-id/wwn-0x500a0751e995bdae-part1";
    fsType = "btrfs";
    options = [
      "defaults"
      "compress=zstd"
      "relatime"
    ];
  };
  # TODO(stylix): move this stuff to separate file but define theme itself per host
  # host-wide styling
  # stylix = {
  #   enable = true;
  #   image = "${pkgs.wallpapers}/share/backgrounds/nix-black-catppuccin.png";
  #   base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
  #   #      cursor = {
  #   #        package = pkgs.foo;
  #   #        name = "";
  #   #      };
  #   #     fonts = {
  #   #monospace = {
  #   #    package = pkgs.foo;
  #   #    name = "";
  #   #};
  #   #sanSerif = {
  #   #    package = pkgs.foo;
  #   #    name = "";
  #   #};
  #   #serif = {
  #   #    package = pkgs.foo;
  #   #    name = "";
  #   #};
  #   #    sizes = {
  #   #        applications = 12;
  #   #        terminal = 12;
  #   #        desktop = 12;
  #   #        popups = 10;
  #   #    };
  #   #};
  #   opacity = {
  #     applications = 1.0;
  #     terminal = 1.0;
  #     desktop = 1.0;
  #     popups = 0.8;
  #   };
  #   polarity = "dark";
  #   # program specific exclusions
  #   #targets.foo.enable = false;
  # };
  #hyprland border override example

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
