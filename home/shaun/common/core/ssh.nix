{
  config,
  inputs,
  lib,
  ...
}:
let
  # There are a subset of hosts where onlykey is used for authentication. An ssh config entry is constructed for each
  # of these hosts that roughly follows the same pattern. Some of these hosts use a domain suffix, so build a list of
  # all hosts with and without domains
  onlykeyHostsWithDomain = [
    "natrix"
    "corais"
    ];

  # Add domain to each host name
  genDomains = lib.map (h: "${h}.${config.hostSpec.domain}");
  onlykeyHostAll = onlykeyHostsWithDomain ++ (genDomains onlykeyHostsWithDomain);
  onlykeyHostsString = lib.concatStringsSep " " onlykeyHostAll;

  # Only a subset of hosts are trusted enough to allow agent forwarding
  forwardAgentHosts = lib.foldl' (acc: b: lib.filter (a: a != b) acc) onlykeyHostsWithDomain ([ ]);
  forwardAgentHostsString = lib.concatStringsSep " " (
    forwardAgentHosts ++ (genDomains forwardAgentHosts)
  );

  pathtokeys = lib.custom.relativeToRoot "hosts/common/users/primary/keys";
  onlykeys =
    lib.lists.forEach (builtins.attrNames (builtins.readDir pathtokeys))
      # Remove the .pub suffix
      (key: lib.substring 0 (lib.stringLength key - lib.stringLength ".pub") key);
  onlykeyPublicKeyEntries = lib.attrsets.mergeAttrsList (
    lib.lists.map (key: { ".ssh/${key}.pub".source = "${pathtokeys}/${key}.pub"; }) onlykeys
  );

  identityFiles = [
    "id_onlykey" # This is an auto symlink to whatever onlykey is plugged in. See modules/common/onlykey
    "id_odin" # fallback to id_manu if onlykeys are not present
  ];

  # Lots of hosts have the same default config, so don't duplicate
  vanillaHosts = [
    "natrix"
    "corais"
    "getula"
  ];
  vanillaHostsConfig = lib.attrsets.mergeAttrsList (
    lib.lists.map (host: {
      "${host}" = lib.hm.dag.entryAfter [ "onlykey-hosts" ] {
        match = "host ${host},${host}.${config.hostSpec.domain}";
        hostname = "${host}.${config.hostSpec.domain}";
        port = config.hostSpec.networking.ports.tcp.ssh;
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

    # Bring in decrypted config
    extraConfig = ''
      UpdateHostKeys ask
    '';

    matchBlocks = {
      # Not all of this systems I have access to can use onlykey.
      "onlykey-hosts" = lib.hm.dag.entryAfter [ "*" ] {
        host = "${onlykeyHostsString}";
        identitiesOnly = true;
        identityFile = lib.lists.forEach identityFiles (file: "${config.home.homeDirectory}/.ssh/${file}");
      };

      # Only forward agent to hosts that need it
      "forward-agent-hosts" = lib.hm.dag.entryAfter [ "onlykey-hosts" ] {
        host = forwardAgentHostsString;
        forwardAgent = true;
      };

      "git" = {
        host = "gitlab.com github.com codeberg.org";
        user = "git";
        forwardAgent = true;
        identitiesOnly = true;
        identityFile = lib.lists.forEach identityFiles (file: "${config.home.homeDirectory}/.ssh/${file}");
      };
    } // vanillaHostsConfig;

  };
  home.file = {
    ".ssh/config.d/.keep".text = "# Managed by Home Manager";
    ".ssh/sockets/.keep".text = "# Managed by Home Manager";
  } // onlykeyPublicKeyEntries;
}

# {
#   config,
#   lib,
#   ...
# }:
# let
#
#   pathtokeys = lib.custom.relativeToRoot "hosts/common/users/primary/keys";
#
#   vanillaHosts = [
#     "natrix"
#     "corais"
#     "getula"
#   ];
#   vanillaHostsConfig = lib.attrsets.mergeAttrsList (
#     lib.lists.map (host: {
#       "${host}" = lib.hm.dag.entryAfter [ "vanilla-hosts" ] {
#         match = "Host ${host},${host}.${config.hostSpec.domain} User ${config.hostSpec.username}";
#         identityFile = "${config.home.homeDirectory}/.ssh/id_odin";
#       };
#     }) vanillaHosts
#   );
# in
# {
#   programs.ssh = {
#     enable = true;
#
#     # FIXME(ssh): This should probably be for git systems only?
#     controlMaster = "auto";
#     controlPath = "${config.home.homeDirectory}/.ssh/sockets/S.%r@%h:%p";
#     controlPersist = "20m";
#     # Avoids infinite hang if control socket connection interrupted. ex: vpn goes down/up
#     serverAliveCountMax = 3;
#     serverAliveInterval = 5; # 3 * 5s
#     hashKnownHosts = true;
#     addKeysToAgent = "yes";
#     extraConfig = ''
#       # Prevent initrd ssh and regular ssh key server IDs wanting to replace eachother
#       UpdateHostKeys ask
#     '';
#
#     matchBlocks = {
#
#       "git" = {
#         host = "gitlab.com github.com codeberg.org";
#         user = "git";
#         forwardAgent = true;
#         identitiesOnly = true;
#         identityFile = "${config.home.homeDirectory}/.ssh/id_mimir";
#       };
#     } // vanillaHostsConfig;
#
#   };
#   home.file =
#     {
#       ".ssh/config.d/.keep".text = "# Managed by Home Manager";
#       ".ssh/sockets/.keep".text = "# Managed by Home Manager";
#     }
#     // lib.attrsets.mergeAttrsList (
#       lib.lists.map (key: { ".ssh/${key}".source = "${pathtokeys}/${key}"; }) (
#         builtins.attrNames (builtins.readDir pathtokeys)
#       )
#     );
# }
