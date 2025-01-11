{
  config,
  lib,
  ...
}:
let
  yubikeyHosts = [
    "genoa"
    "ghost"
    "gooey"
    "grief"
    "guppy"
    "gusto"
  ];
  # add my domain to each yubikey host
  yubikeyDomains = map (h: "${h}.${config.hostSpec.domain}") yubikeyHosts;
  yubikeyHostAll = yubikeyHosts ++ yubikeyDomains;
  yubikeyHostsString = lib.concatStringsSep " " yubikeyHostAll;

  pathtokeys = lib.custom.relativeToRoot "hosts/common/users/primary/keys";
  yubikeys =
    lib.lists.forEach (builtins.attrNames (builtins.readDir pathtokeys))
      # Remove the .pub suffix
      (key: lib.substring 0 (lib.stringLength key - lib.stringLength ".pub") key);
  yubikeyPublicKeyEntries = lib.attrsets.mergeAttrsList (
    lib.lists.map
      # list of dicts
      (key: { ".ssh/${key}.pub".source = "${pathtokeys}/${key}.pub"; })
      yubikeys
  );

  vcsIdentityFiles = [
    "id_mimir" # for VCS
  ];
  identityFiles = [
    "id_odin"
  ];

  # Lots of hosts have the same default config, so don't duplicate
  vanillaHosts = [
    "natrix"
    "corais"
  ];
  vanillaHostsConfig = lib.attrsets.mergeAttrsList (
    lib.lists.map (host: {
      "${host}" = lib.hm.dag.entryAfter [ "yubikey-hosts" ] {
        host = host;
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

    # FIXME:(ssh) This should probably be for git systems only?
    controlMaster = "auto";
    controlPath = "~/.ssh/sockets/S.%r@%h:%p";
    controlPersist = "10m";

    # req'd for enabling yubikey-agent
    extraConfig = ''
      AddKeysToAgent yes
    '';

    matchBlocks = {
      # Not all of this systems I have access to can use yubikey.
      # "yubikey-hosts" = lib.hm.dag.entryAfter [ "*" ] {
      #   host = "${yubikeyHostsString}";
      #   forwardAgent = true;
      #   identitiesOnly = true;
      #   identityFile = lib.lists.forEach identityFiles (file: "${config.home.homeDirectory}/.ssh/${file}");
      # };

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
  } // yubikeyPublicKeyEntries;
}
