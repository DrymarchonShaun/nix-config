{
  config,
  configVars,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.autoLogin;
in
{
  # Declare custom options for conditionally enabling auto login
  options.autoLogin = {
    enable = lib.mkEnableOption "Enable automatic login";

    username = lib.mkOption {
      type = lib.types.str;
      default = "${configVars.username}";
      description = "User to automatically login";
    };
  };

  config = {
    services.greetd = {
      enable = true;

      restart = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --asterisks --time --time-format '%I:%M %p | %a • %h | %F' --cmd sway";
          user = "${configVars.username}";
        };

        initial_session = lib.mkIf cfg.enable {
          command = "${lib.getExe
            config.home-manager.users.${configVars.username}.wayland.windowManager.sway.package
          }";
          user = "${cfg.username}";
        };
      };
    };
  };
}
