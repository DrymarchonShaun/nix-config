{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.steam.launchOptions;
  launch-options = pkgs.writeText "steam-launch-options.json" (builtins.toJSON cfg.options);
in
{
  options.programs.steam.launchOptions = {
    enable = lib.mkEnableOption "Steam launch options management";

    options = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        "730" = "-novid -console";
        "440" = "-windowed -noborder";
      };
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
      reloadTriggers = [ launch-options ];
      serviceConfig = {
        ExecStartPre = "${pkgs.steam-launch-options-merger}/bin/steam-launch-options-merger --launch-options ${launch-options}";
      };
    };

  };
}
