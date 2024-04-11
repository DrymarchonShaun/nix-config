{ modulesPath, config, lib, pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  environment.systemPackages = map lib.lowPrio [
    pkgs.rsync
    #pkgs.curl
    #pkgs.gitMinimal
  ];

  users.users.ta.password = "nixos";
  extraGroups = [ "wheel" ];
  users.users.ta.openssh.authorizedKeys.keys = [
    # Add all keys for ease of access depending on where install is occurring.
    (builtins.readFile ../hosts/common/users/ta/keys/id_maya.pub)
    (builtins.readFile ../hosts/common/users/ta/keys/id_mara.pub)
    (builtins.readFile ../hosts/common/users/ta/keys/id_manu.pub)
    (builtins.readFile ../hosts/common/users/ta/keys/id_meek.pub)
  ];

  system.stateVersion = "23.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
