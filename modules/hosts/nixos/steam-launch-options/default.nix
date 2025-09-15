{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.programs.steam.launchOptions;

  # if possible, use modules/common/monitors.nix to determine resolution for gamescope, otherwise use a sane default
  monitor =
    if config ? monitors && config.monitors != [ ] then
      lib.head (lib.filter (m: m.primary) config.monitors)
    else
      {
        width = 1920;
        height = 1080;
        refreshRate = 60;
      };

  launchOptionsJson = pkgs.writeText "steam-launch-options.json" (
    builtins.toJSON (
      lib.mapAttrs (
        _: v:
        lib.concatStringsSep " " (
          lib.flatten [
            (v.preExtraEnvVars or false)
            (lib.optional v.gamescope "MANGOHUD=0")
            (v.extraEnvVars or false)
            (v.preExtraPrefixCommand or false)
            "gamemoderun"
            (v.extraPrefixCommand or false)
            (lib.optional v.gamescope "gamescope -W ${builtins.toString monitor.width} -H ${builtins.toString monitor.height} -w ${builtins.toString monitor.width} -h ${builtins.toString monitor.height} -r ${builtins.toString monitor.refreshRate} -f --mangoapp ${(lib.optionalString v.captureCursor "--force-grab-cursor")} --")
            "%command%"
            (v.extraGameOptions or false)
          ]
        )
      ) cfg.options
    )
  );

in
{
  options.programs.steam.launchOptions = {
    enable = lib.mkEnableOption "Steam launch options management";

    options = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { ... }:
          {
            options = {
              gamescope = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              captureCursor = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              preExtraEnvVars = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
              extraEnvVars = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
              preExtraPrefixCommand = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
              extraPrefixCommand = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
              extraGameOptions = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
            };
          }
        )
      );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        steam-launch-options-merger = final.callPackage ./package.nix {
          inherit final;
        };
      })
    ];

    systemd.user.services.steam = {
      reloadTriggers = [ launchOptionsJson ];
      serviceConfig.ExecStartPre = "${pkgs.steam-launch-options-merger}/bin/steam-launch-options-merger --launch-options ${launchOptionsJson}";
    };
  };
}
