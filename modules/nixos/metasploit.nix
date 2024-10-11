{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.metasploit;
in
{
  options.programs.metasploit = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable or disable the Metasploit Framework.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.metasploit;
      description = "Package to use for Metasploit.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
