{
  config,
  lib,
  ...
}:
let

  pathtokeys = lib.custom.relativeToRoot "hosts/common/users/primary/keys";

  vanillaHosts = [
    "natrix"
    "corais"
    "getula"
  ];
  vanillaHostsConfig = lib.attrsets.mergeAttrsList (
    lib.lists.map (host: {
      "${host}" = lib.hm.dag.entryAfter [ "vanilla-hosts" ] {
        match = "Host ${host},${host}.${config.hostSpec.domain} User ${config.hostSpec.username}";
        identityFile = "${config.home.homeDirectory}/.ssh/id_odin";
      };
    }) vanillaHosts
  );
in
{
  programs.ssh = {
    enable = true;

    # FIXME(ssh): This should probably be for git systems only?
    controlMaster = "auto";
    controlPath = "${config.home.homeDirectory}/.ssh/sockets/S.%r@%h:%p";
    controlPersist = "20m";
    # Avoids infinite hang if control socket connection interrupted. ex: vpn goes down/up
    serverAliveCountMax = 3;
    serverAliveInterval = 5; # 3 * 5s
    hashKnownHosts = true;
    addKeysToAgent = "yes";
    extraConfig = ''
      # Prevent initrd ssh and regular ssh key server IDs wanting to replace eachother
      UpdateHostKeys ask
    '';

    matchBlocks = {

      "git" = {
        host = "gitlab.com github.com codeberg.org";
        user = "git";
        forwardAgent = true;
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/id_mimir";
      };
    } // vanillaHostsConfig;

  };
  home.file =
    {
      ".ssh/config.d/.keep".text = "# Managed by Home Manager";
      ".ssh/sockets/.keep".text = "# Managed by Home Manager";
    }
    // lib.attrsets.mergeAttrsList (
      lib.lists.map (key: { ".ssh/${key}".source = "${pathtokeys}/${key}"; }) (
        builtins.attrNames (builtins.readDir pathtokeys)
      )
    );
}
