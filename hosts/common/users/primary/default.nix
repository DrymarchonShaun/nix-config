# User config applicable to both nixos and darwin
{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  hostSpec = config.hostSpec;
  pubKeys = lib.filesystem.listFilesRecursive ./keys;
in
{
  users.users.${hostSpec.username} =
    {
      name = hostSpec.username;
      shell = pkgs.zsh; # default shell

      # These get placed into /etc/ssh/authorized_keys.d/<name> on nixos
      # openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);
      openssh.authorizedKeys.keyFiles = [ ./keys/id_odin.pub ];
    }
    #FIXME: remove this define in the iso and installer using mkForce
    // lib.optionalAttrs (hostSpec.isMinimal || hostSpec.hostName == "iso") {
      # This gets overridden if sops is working, only used on iso/nixos-installer
      password = "nixos";
    };

  # Create ssh sockets directory for controlpaths when homemanager not loaded (i.e. isMinimal)
  systemd.tmpfiles.rules =
    let
      user = config.users.users.${hostSpec.username}.name;
      group = config.users.users.${hostSpec.username}.group;
    in
    [ "d /home/${hostSpec.username}/.ssh/sockets 0750 ${user} ${group} -" ];

  # No matter what environment we are in we want these tools
  programs.zsh.enable = true;
  environment.systemPackages = [
    pkgs.just
    pkgs.rsync
  ];
}
# Import the user's personal/home configurations, unless the environment is minimal
// lib.optionalAttrs (inputs ? "home-manager") {
  home-manager = {
    extraSpecialArgs = {
      inherit pkgs inputs;
      hostSpec = config.hostSpec;
    };
    users.${hostSpec.username}.imports = lib.flatten (
      lib.optional (!hostSpec.isMinimal) [
        (
          { config, ... }:
          import (lib.custom.relativeToRoot "home/${hostSpec.username}/${hostSpec.hostName}.nix") {
            inherit
              pkgs
              inputs
              config
              lib
              hostSpec
              ;
          }
        )
      ]
    );
  };
}
