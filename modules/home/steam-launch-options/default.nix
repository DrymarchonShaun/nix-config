{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.steam.launchOptions;

  mergerScript = pkgs.python3Packages.buildPythonApplication rec {
    name = "steam-launch-options-merger";
    version = "1.0.0";
    pyproject = false;

    dontUnpack = true;

    dependencies = with pkgs.python3Packages; [
      vdf
    ];

    installPhase = ''
      install -Dm755 ${./steam-launch-options-merger.py} $out/bin/steam-launch-options-merger
    '';
  };
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
  # FIXME: restarting steam isn't working

  config = lib.mkIf cfg.enable {
    home.activation.steamLaunchOptions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Stop Steam if running
      ${lib.getExe' pkgs.procps "pkill"} steam || true

      # Wait until Steam is stopped
      while ${lib.getExe' pkgs.procps "pgrep"} steam >/dev/null; do
        sleep 1
      done

      # Run the merger script
      ${mergerScript}/bin/steam-launch-options-merger \
        --launch-options ${lib.escapeShellArg (builtins.toJSON cfg.options)}
    '';
  };
}
