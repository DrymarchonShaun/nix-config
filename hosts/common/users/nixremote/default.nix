{
  pkgs,
  inputs,
  config,
  lib,
  configVars,
  configLib,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  sopsHashedPasswordFile =
    lib.optionalString (lib.hasAttr "sops-nix" inputs)
      config.sops.secrets."${configVars.username}/password".path;
  pubKeys = lib.filesystem.listFilesRecursive (./keys/ssh);
in
#this is the second argument to recursiveUpdate
{
  users.mutableUsers = false; # Only allow declarative credentials; Required for sops
  users.users.remotebuilder = {
    isNormalUser = true;

    extraGroups = ifTheyExist [
      "git"
    ];

    # These get placed into /etc/ssh/authorized_keys.d/<name> on nixos
    # openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);

    shell = pkgs.zsh; # default shell
  };
}
