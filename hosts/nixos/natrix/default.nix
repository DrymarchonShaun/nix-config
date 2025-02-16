#############################################################
#
#  Ghost - Main Desktop
#  NixOS running on Ryzen 5 3600X, Radeon RX 5700 XT, 64GB RAM
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
  natrixKernel = pkgs.linux_6_11.override { };
  natrixKernelPackages = (pkgs.linuxPackagesFor natrixKernel).extend (
    final: prev: {
      # system76 = (pkgs.linuxPackagesFor natrixKernel).system76.overrideAttrs (attrs: {
      #   #   version = "1.0.13-unstable";
      #   #   src = attrs.src // {
      #   #     rev = "341bcde2d280e384261019baec1496acf5d04d95";
      #   #     sha256 = "";
      #   #   };
      #   patches = [
      #     (pkgs.fetchpatch {
      #       name = "fix-linux-6_12-build.patch";
      #       url = "https://github.com/pop-os/system76-dkms/pull/71.patch";
      #       hash = "sha256-skJI1CXwR6rNn3aEPYB7rnvra24W8vtfBmM71d3BD1w=";
      #     })
      #   ];
      # });
      #    zenergy = final.callPackage ../../pkgs/zenergy { };
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
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    #
    # ========== Disk Layout ==========
    #
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/natrix.nix")

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
      "hosts/common/optional/services/avahi.nix" # host discovery
      "hosts/common/optional/services/bluetooth.nix" # bluetooth
      "hosts/common/optional/services/geoclue.nix" # location services
      "hosts/common/optional/services/greetd.nix" # display manager
      "hosts/common/optional/services/syncthing.nix" # syncthing
      "hosts/common/optional/services/network-manager.nix" # display manager
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/services/polkit.nix" # allow remote SSH access
      "hosts/common/optional/services/printing.nix" # CUPS
      "hosts/common/optional/services/ydotool.nix" # CUPS
      "hosts/common/optional/virtualization/flatpak" # container subsystem, primarily used for sober (roblox)
      "hosts/common/optional/virtualization/containers/openbooks.nix"
      "hosts/common/optional/android.nix" # adb / fastboot
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/fonts.nix" # vm tools
      "hosts/common/optional/gaming.nix" # steam, gamescope, gamemode, and related hardware
      "hosts/common/optional/libvirt.nix" # vm tools
      "hosts/common/optional/nvtop.nix" # GPU monitor (not available in home-manager)
      "hosts/common/optional/plymouth.nix" # fancy boot screen
      "hosts/common/optional/recording.nix" # obs / virtual camera
      "hosts/common/optional/scanning.nix" # SANE and simple-scan
      "hosts/common/optional/hyprland.nix" # window manager
      "hosts/common/optional/thunar.nix" # file manager
      "hosts/common/optional/unbound.nix" # dns server
      "hosts/common/optional/vlc.nix" # media player
    ])
    #
    # ========== Natrix Specific ==========
    #

  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "natrix";
    useYubikey = lib.mkForce false;
    hdr = lib.mkForce false;
  };

  # set custom autologin options. see greetd.nix for details
  #  autoLogin.enable = true;
  #  autoLogin.username = config.hostSpec.username;
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
    kernelPackages = natrixKernelPackages;
    kernelParams = [ "acpi_backlight=native" ];
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
    systemd.enable = true;
  };

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

  # needed to unlock LUKS on secondary drives
  # use partition UUID
  # https://wiki.nixos.org/wiki/Full_Disk_Encryption#Unlocking_secondary_drives
  environment.etc.crypttab.text = lib.optionalString (!config.hostSpec.isMinimal) ''
    cryptextra /dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b456ba8d0-part1 /.luks-secondary-unlock.key luks
  '';

  services.udev.extraRules = lib.optionalString (!config.hostSpec.isMinimal) ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
  '';

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
  #  wayland.windowManager.hyprland.settings.general."col.active_border" = lib.mkForce "rgb(${config.stylix.base16Scheme.base0E});

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
