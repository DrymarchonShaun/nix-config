# This module supports multiple OnlyKey and OnlyKey Duo devices by referencing an arbitrary string stored in the label of the last slot on the device (12th/6B on the Original OnlyKey, 24th/Purple 3B on the OnlyKey DUO).

{
  config,
  pkgs,
  lib,
  ...
}:
let
  homeDirectory = "${config.hostSpec.home}";
  onlykey-up = pkgs.python3Packages.buildPythonApplication {
    name = "onlykey-up";
    pyproject = false;

    dontUnpack = true;

    dependencies = with pkgs; [
      onlykey-python
    ];

    installPhase = ''
      install -Dm755 ${./onlykey-up.py} $out/bin/onlykey-up
    '';
  };
  onlykey-down = pkgs.writeShellApplication {
    name = "onlykey-down";
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      rm ${homeDirectory}/.ssh/id_onlykey
      rm ${homeDirectory}/.ssh/id_onlykey.pub
    '';
  };
in
{
  options = {
    onlykey = {
      enable = lib.mkEnableOption "Enable onlykey support";
      identifiers = lib.mkOption {
        default = { };
        type = lib.types.listOf lib.types.str;
        description = "List of identifiers for onlykey devices. As onlykey devices don't have any unique identifiers, this is a list of unique (arbitrary) strings placed in the 12th (Original OnlyKey) or 24th (OnlyKey DUO) label on each security key, to act as an identifier. This \'name\' is used to make symbolic links to the SSH keys in the user's home directory.";
        example = lib.literalExample ''
          [
          "Emoryi"
          "Dione"
          ]
        '';
      };
    };
  };
  config = lib.mkIf config.onlykey.enable {
    environment.systemPackages = lib.flatten [
      (builtins.attrValues {
        inherit (pkgs)
          onlykey
          onlykey-cli

          pam_u2f # for onlykey with sudo
          ;
      })
    ];

    services.udev.extraRules = ''
      # Link/unlink ssh key on onlykey add/remove
      SUBSYSTEM=="usb", \
      ATTR{idVendor}=="1d50", \
      ATTR{idProduct}=="60fc", \
      ACTION=="add", \
      TAG+="systemd", \
      ENV{SYSTEMD_WANTS}="onlykey-up.service"

      SUBSYSTEM=="usb", \
      ENV{PRODUCT}=="1d50/60fc/100", \
      ENV{DEVTYPE}=="usb_device", \
      ACTION=="remove", \
      RUN+="${onlykey-down}/bin/onlykey-down"
    '';

    systemd.services.onlykey-up = {
      description = "OnlyKey Up Service";
      serviceConfig = {
        User = config.hostSpec.username;
        Type = "oneshot";
        ExecStart = "${onlykey-up}/bin/onlykey-up";
      };
    };

    # onlykey login / sudo

    hardware.onlykey.enable = lib.mkIf pkgs.stdenv.isLinux true;

    security.pam = lib.optionalAttrs pkgs.stdenv.isLinux {
      u2f = {
        enable = true;
        settings = {
          cue = true; # Tells user they need to press the button
          authfile = lib.mkDefault (
            builtins.toFile "u2f_mappings" (
              lib.concatMapStringsSep "\n"
                (
                  user:
                  lib.concatStringsSep ":" [
                    user
                    # emoryi?
                    "Ro7I25yXbMXYVhqvNSfPLlyMv04HzOog9FSl7IKEJQDnCwTZUgzooeDmD3JBaS7k008fyKKFVKtDfGu4NH/WCcy7PxA/Ag==,MfGalBUj6xMDzWXZsXw0WzNad2nA/PTjEEg4XYnqK7omuFUy3UCPCjPF5M4YTMXxsX1+i5t/+k3eEL+N3NCW2Q==,es256,+presence"
                    # dione?
                    "nreWoi4mHKKCU/LUPghjYwgUlbOK6U0VTpwQDy2IvJ41sgTZUgzooeDmD3JBaS7k008fyKKFVKtDfGu4NH/WCcy7nw4/Ag==,4jK9wAWKxjpjqLIAyaHsMqycwInDmsBN28iUpZ4Mg3FUCqyO8o45IqKVwq3avWt2A+kOVETW/zBp33/sKMNTig==,es256,+presence"
                  ]
                )
                [
                  config.hostSpec.username
                  # more users if needed
                ]
            )
          );

        };
      };
      services = {
        login.u2fAuth = true;
        sudo = {
          u2fAuth = true;
        };
      };
    };
  };
}
