{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.create_ap;
  configFile = cfg.configPath;
in
{
  options = {
    services.create_ap = {
      configPath = lib.mkOption {
        type = lib.types.str;
        default = pkgs.writeText "create_ap.conf" (lib.generators.toKeyValue { } cfg.settings);
        description = lib.mdDoc ''
          Configuration file path for `create_ap`, overrides settings.
          See [upstream example configuration](https://raw.githubusercontent.com/lakinduakash/linux-wifi-hotspot/master/src/scripts/create_ap.conf)
          for supported values.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      services.create_ap = {
        restartTriggers = lib.mkForce [ configFile ];
        serviceConfig = {
          ExecStart = lib.mkForce "${pkgs.linux-wifi-hotspot}/bin/create_ap --config ${configFile}";
        };
      };
    };

  };

}
