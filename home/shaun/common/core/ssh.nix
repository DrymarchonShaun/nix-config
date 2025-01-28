{
  config,
  lib,
  ...
}:
let

  pathtokeys = lib.custom.relativeToRoot "hosts/common/users/primary/keys";
  keys =
    lib.lists.forEach (builtins.attrNames (builtins.readDir pathtokeys))
      # Remove the .pub suffix
      (key: lib.substring 0 (lib.stringLength key - lib.stringLength ".pub") key);
  publicKeyEntries = lib.attrsets.mergeAttrsList (
    lib.lists.map (key: {
      ".ssh/${key}.pub".source = "${pathtokeys}/${key}.pub";
    }) keys
  );

  vcsIdentityFiles = [
    "id_mimir"
  ];
  identityFiles = [
    "id_odin"
  ];

  vanillaHosts = [
    "natrix"
    "corais"
  ];
  vanillaHostsConfig = lib.attrsets.mergeAttrsList (
    lib.lists.map (host: {
      "${host}" = lib.hm.dag.entryAfter [ "vanilla-hosts" ] {
        match = "host ${host},${host}.${config.hostSpec.domain}";
        hostname = "${host}.${config.hostSpec.domain}";
        port = config.hostSpec.networking.ports.tcp.ssh;
        forwardAgent = true;
        identityFile = lib.lists.forEach identityFiles (file: "${config.home.homeDirectory}/.ssh/${file}");
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
    #updateHostKeys = "ask";
    hashKnownHosts = true;
    addKeysToAgent = "yes";
    # Bring in decrypted config
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
        identityFile = lib.lists.forEach vcsIdentityFiles (
          file: "${config.home.homeDirectory}/.ssh/${file}"
        );
      };
    } // vanillaHostsConfig;

  };
  home.file = {
    ".ssh/config.d/.keep".text = "# Managed by Home Manager";
    ".ssh/sockets/.keep".text = "# Managed by Home Manager";
  } // publicKeyEntries;
}
