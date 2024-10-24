{
  config,
  configVars,
  configLib,
  pkgs,
  lib,
  ...
}:
let
  pathtokeys = configLib.relativeToRoot "hosts/common/users/${configVars.username}/keys/ssh";
  publicKeys =
    lib.lists.forEach (builtins.attrNames (builtins.readDir pathtokeys))
      # Remove the .pub suffix
      (key: lib.substring 0 (lib.stringLength key - lib.stringLength ".pub") key);
  PublicKeyEntries = lib.attrsets.mergeAttrsList (
    lib.lists.map
      # list of dicts
      (key: { ".ssh/${key}.pub".source = "${pathtokeys}/${key}.pub"; })
      publicKeys
  );

  # Lots of hosts have the same default config, so don't duplicate
  vanillaHosts = [
    "natrix"
    "corais"
  ];
  vanillaHostsConfig = lib.attrsets.mergeAttrsList (
    lib.lists.map (host: {
      "${host}" = {
        host = host;
        hostname = "${host}.${configVars.domain}";
        port = configVars.networking.ports.tcp.ssh;
        forwardAgent = true;
      };
    }) vanillaHosts
  );
in
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  programs.ssh = {
    enable = true;

    # FIXME: This should probably be for git systems only?
    controlMaster = "auto";
    controlPath = "~/.ssh/sockets/S.%r@%h:%p";
    controlPersist = "10m";

    matchBlocks = {
      "git" = {
        host = "gitlab.com github.com";
        user = "git";
        forwardAgent = true;
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/id_mimir";
      };
    } // vanillaHostsConfig;

  };

  sops.secrets = {
    "ssh_keys/mimir" = {
      path = "${config.home.homeDirectory}/.ssh/id_mimir";
    };
    "ssh_keys/odin" = {
      path = "${config.home.homeDirectory}/.ssh/id_odin";
    };
  };

  home.file = {
    ".ssh/config.d/.keep".text = "# Managed by Home Manager";
    ".ssh/sockets/.keep".text = "# Managed by Home Manager";
  } // PublicKeyEntries;
}
