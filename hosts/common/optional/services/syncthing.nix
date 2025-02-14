{
  config,
  lib,
  ...
}:
{
  # Initialize the certificate and key for the current host, and the device IDs for all devices
  sops.secrets = {
    "keys/syncthing/cert" = {
      owner = config.hostSpec.username;
      mode = "0400";
    };
    "keys/syncthing/key" = {
      owner = config.hostSpec.username;
      mode = "0400";
    };
  };

  services.syncthing = {
    enable = true;
    user = config.hostSpec.username;
    configDir = "${config.hostSpec.home}/.config/syncthing";
    dataDir = "${config.hostSpec.home}/.local/share/syncthing";
    cert = config.sops.secrets."keys/syncthing/cert".path;
    key = config.sops.secrets."keys/syncthing/key".path;
    settings = {
      folders =
        let
          defaultFolder =
            name: override:
            {
              name = name;
              id = lib.mkDefault name;
              path = lib.mkDefault "${config.hostSpec.home}/${name}";
              devices = [
                "corais"
                "natrix"
              ];
              versioning = lib.mkDefault {
                type = "trashcan";
                params.cleanoutDays = "30";
              };
            }
            // override;
        in
        {
          "Documents" = defaultFolder "Documents" {
            devices = [
              "corais"
              "natrix"
              "getula"
            ];
          };
          "Games" = defaultFolder "Games" {
            path = "${config.hostSpec.home}/Games/Shared";
          };
          "Music" = defaultFolder "Music" { };
          "Pictures" = defaultFolder "Pictures" { };
          "Videos" = defaultFolder "Videos" { };
          "Books" = defaultFolder "Books" {
            path = "${config.hostSpec.home}/Calibre Library";
            devices = [
              "corais"
              "natrix"
              "dekayi"
              "getula"
            ];
          };
          "PrismInstances" = defaultFolder "PrismInstances" {
            path = "${config.hostSpec.home}/.local/share/PrismLauncher/instances";
          };
        };
      devices = {
        "corais" = {
          name = "corais";
          id = "W5JER46-RSQZAN2-W23UZIV-OII3TXG-KBTUBN3-B3PWGMZ-UOTO2FM-HSDETAA";
        };
        "natrix" = {
          name = "natrix";
          id = "X4FK4LK-BYRXQ6I-YZLAV2C-C42ZISO-I5XTVCW-EQJHONW-3AZPXDT-M3LFVAF";
        };
        "dekayi" = {
          name = "dekayi";
          id = "2VG3CY3-ECCBLGF-V4E3OMN-X5NERGR-PNZ664G-MVY5VTL-TSCM3GY-IZ5WHAH";
        };
        "getula" = {
          name = "getula";
          id = "2INLTFY-LID25YN-MDYG5GD-CHINDJH-JWJ6BUC-AQBH4L3-4SEND3E-6RBW3QW";
        };
      };
    };
  };
}
