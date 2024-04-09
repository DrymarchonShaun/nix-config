{ pkgs, inputs, config, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  # Decrypt ta-password to /run/secrets-for-users/ so it can be used to create the user
  sops.secrets.shaun-password.neededForUsers = true;


  users.mutableUsers = false; # Required for password to be set via sops during system activation!

  users.users.shaun = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.shaun-password.path;
    shell = pkgs.zsh; # default shell
    extraGroups = [
      "wheel"
      "audio"
      "video"
    ] ++ ifTheyExist [
      "docker"
      "git"
      "network"
    ];

    openssh.authorizedKeys.keys = [
      (builtins.readFile ./keys/id_mimir.pub)
      #exclude id_meek which should only be used during installation
    ];

    packages = [ pkgs.home-manager ];
  };

  # Import this user's personal/home configurations
  home-manager.users.shaun = import ../../../../home/shaun/${config.networking.hostName}.nix;

}
