{
  pkgs,
  configLib,
  lib,
  ...
}:
let
  pubKeys = lib.filesystem.listFilesRecursive (
    configLib.relativeToRoot "hosts/common/users/nixremote/keys/ssh"
  );
in
{
  nix.settings.trusted-users = [ "nixremote" ];
  users.groups.nixremote = { };
  users.users.nixremote = {
    isSystemUser = true;
    home = "/home/nixremote";
    createHome = true;
    homeMode = "700";
    group = "nixremote";
    # These get placed into /etc/ssh/authorized_keys.d/<name> on nixos
    openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);

    shell = pkgs.zsh; # default shell
  };
  sops.secrets."ssh_keys/dvergar" = {
    path = "/home/nixremote/.ssh/id_dvergar";
    mode = "400";
    owner = "nixremote";
    group = "nixremote";
  };
}
