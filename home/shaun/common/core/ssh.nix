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

  identityFiles = [
    "id_mimir" # for VCS
    "id_odin" # fallback to id_odin
  ];

  # Lots of hosts have the same default config, so don't duplicate
  vanillaHosts = [
    "natrix"
    "corais"
    "genoa"
    "ghost"
    "grief"
    "guppy"
    "gusto"
  ];
  vanillaHostsConfig = lib.attrsets.mergeAttrsList (
    lib.lists.map (host: {
      "${host}" = lib.hm.dag.entryAfter [ "yubikey-hosts" ] {
        host = host;
        hostname = "${host}.${config.hostSpec.domain}";
        port = config.hostSpec.networking.ports.tcp.ssh;
        forwardAgent = true;
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
        host = "gitlab.com github.com";
        user = "git";
        forwardAgent = true;
        identitiesOnly = true;
        identityFile = lib.lists.forEach identityFiles (file: "${config.home.homeDirectory}/.ssh/${file}");
      };
      # "gooey" = lib.hm.dag.entryAfter [ "yubikey-hosts" ] {
      #   host = "gooey";
      #   hostname = "gooey.${config.hostSpec.domain}";
      #   user = "pi";
      #   forwardAgent = true;
      #   identitiesOnly = true;
      #   identityFile = lib.lists.forEach identityFiles (file: "${config.home.homeDirectory}/.ssh/${file}");
      # };
      # "oops" = lib.hm.dag.entryAfter [ "yubikey-hosts" ] {
      #   host = "oops";
      #   hostname = "${config.hostSpec.networking.subnets.oops.ip}";
      #   user = "${config.hostSpec.username}";
      #   port = config.hostSpec.networking.subnets.oops.port;
      #   forwardAgent = true;
      #   identitiesOnly = true;
      #   identityFile = [
      #     "~/.ssh/id_yubikey"
      #     "~/.ssh/id_borg"
      #   ];
      # };
      # "cakes" = {
      #   host = "${config.hostSpec.networking.external.cakes.name}";
      #   hostname = "${config.hostSpec.networking.external.cakes.ip}";
      #   user = "${config.hostSpec.networking.external.cakes.username}";
      #   localForwards = [
      #     {
      #       bind.address = "localhost";
      #       bind.port = config.hostSpec.networking.external.cakes.localForwardsPort;
      #       host.address = "localhost";
      #       host.port = config.hostSpec.networking.external.cakes.localForwardsPort;
      #     }
      #   ];
      # };
    } // vanillaHostsConfig;

  };
  home.file = {
    ".ssh/config.d/.keep".text = "# Managed by Home Manager";
    ".ssh/sockets/.keep".text = "# Managed by Home Manager";
  } // yubikeyPublicKeyEntries;
}
