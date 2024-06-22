#############################################################
#
#  Natrix - darp8
#  NixOS running on System76 Darter Pro
#
###############################################################

{ inputs, lib, pkgs, configLib, ... }: {
  imports = [
    #################### Every Host Needs This ####################
    ./hardware-configuration.nix

    #################### Hardware Modules ####################
    inputs.hardware.nixosModules.common-cpu-intel
    # inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    #################### Disk Layout ####################
    #  inputs.disko.nixosModules.disko
    #  (configLib.relativeToRoot "hosts/common/disks/standard-disk-config.nix")
    #  {
    #    _module.args = {
    #      disk = "/dev/nvme0n1";
    #      swapSize = "16";
    #      withSwap = false;
    #    };
    #  }
  ]
  ++ (map configLib.relativeToRoot [
    #################### Required Configs ####################
    "hosts/common/core"

    #################### Host-specific Optional Configs ####################
    "hosts/common/optional/services/openssh.nix"
    "hosts/common/optional/services/geoclue.nix"
    "hosts/common/optional/services/gvfs.nix"
    "hosts/common/optional/services/bluetooth.nix"
    "hosts/common/optional/unbound.nix"
    "hosts/common/optional/openbooks.nix"

    # Desktop
    # "hosts/common/optional/hyprland.nix" # window manager
    "hosts/common/optional/sway.nix" # window manager
    "hosts/common/optional/pipewire.nix" # audio
    "hosts/common/optional/steam.nix"
    #################### Users to Create ####################
    "hosts/common/users/shaun"

  ]);

  hardware = {
    system76.enableAll = true;
    # system76.power-daemon.enable = lib.mkForce false;
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
  '';


  services.gnome.gnome-keyring.enable = true;
  # TODO enable and move to greetd area? may need authentication dir or something?
  # services.pam.services.greetd.enableGnomeKeyring = true;

  networking = {
    hostName = "natrix";
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
  };

  fileSystems."/run/media/shaun/storage" = {
    device = "/dev/mapper/luksmnt";
    options = [ "nofail" "noatime" ];
  };


  # environment.systemPackages = [ pkgs.libsForQt5.qtstyleplugin-kvantum pkgs.qt6Packages.qtstyleplugin-kvantum ];

  environment.etc = {
    crypttab = {
      text = ''
        luksmnt /dev/disk/by-partlabel/storage /etc/.cryptkey luks,nofail
      '';
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
