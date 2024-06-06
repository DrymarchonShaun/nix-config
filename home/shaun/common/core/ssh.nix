{ outputs, pkgs, lib, ... }:
{
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-all;
    enableSshSupport = true;
  };

  programs.ssh = {
    enable = true;

    matchBlocks = {
      "VCS" = {
        host = "gitlab.com github.com";
        identitiesOnly = true;
        identityFile = [
          "~/.ssh/id_mimir"
        ];
      };
    };
    # FIXME: This should probably be for git systems only?
    #controlMaster = "auto";
    #controlPath = "~/.ssh/sockets/S.%r@%h:%p";
    #controlPersist = "60m";

    #extraConfig = ''
    #Include config.d/*
    #'';
  };
  #  home.file.".ssh/sockets/.keep".text = "# Managed by Home Manager";
}
