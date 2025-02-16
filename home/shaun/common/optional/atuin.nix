{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  sopsFolder = (builtins.toString inputs.nix-secrets) + "/sops";

  inherit (pkgs.stdenv) isLinux isDarwin;

  atuin = "${config.programs.atuin.package}/bin/atuin";

  automaticLogin = config.programs.atuin.enable;
  automaticLoginScript = pkgs.writeShellScript "automatic-atuin-login.sh" ''
    if [ -e ${config.home.homeDirectory}/.local/share/atuin/session ]; then
      echo "atuin session exists already"
    else
      echo "Logging into atuin server"
      ${atuin} login \
        -u "${config.hostSpec.usernames.atuin}" \
        -p "$(cat ${config.sops.secrets."passwords/misc/atuin".path})" \
        -k "$(cat ${config.sops.secrets."keys/atuin".path})"
    fi
  '';
in
lib.mkMerge [
  {
    sops.secrets = {
      "passwords/misc/atuin" = {
        sopsFile = "${sopsFolder}/shared.yaml";
      };
      "keys/atuin" = {
        sopsFile = "${sopsFolder}/shared.yaml";
      };
    };
  }
  {
    programs.atuin = {
      enable = true;
      flags = [ ];
      settings = {
        update_check = false;
        sync_frequency = "15m";
        search_mode = "fuzzy";
        inline_height = 33;
        enter_accept = "true";
        common_subcommands = [ "nixos" ];
        common_prefix = [ "sudo" ];
        daemon = {
          enabled = true;
        };
      };
    };
    programs.zsh.initExtra = ''
      bindkey '^r' _atuin_search_widget
    '';
  }
  (lib.mkIf isLinux {

    programs.atuin = {
      settings = {
        daemon = {
          systemd_socket = true;
        };
      };
    };
    home.sessionVariables = {
      ATUIN_DAEMON__SOCKET_PATH = "$XDG_RUNTIME_DIR/atuin.sock";
    };

    systemd.user.services.atuin-daemon = {
      Unit = {
        Description = "atuin daemon";
        After = lib.optionals automaticLogin [ "sops-nix.service" ];
        Requires = [ "atuin-daemon.socket" ];
      };
      Install = {
        Also = [ "atuin-daemon.socket" ];
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${atuin} daemon";
        Environment = [
          "ATUIN_LOG=info"
          "ATUIN_DAEMON__SOCKET_PATH=%t/atuin.sock"
        ];
        Restart = "on-failure";
        RestartSteps = 3;
        RestartMaxDelaySec = 6;
      };
    };

    systemd.user.sockets.atuin-daemon = {
      Unit = {
        Description = "atuin daemon socket";
      };
      Install = {
        WantedBy = [ "sockets.target" ];
      };
      Socket = {
        ListenStream = "%t/atuin.sock";
        SocketMode = "0600";
        RemoveOnStop = true;
      };
    };

    systemd.user.services.atuin-automatic-login = lib.mkIf automaticLogin {
      Unit = {
        Description = "automatic atuin login";
        Requires = [
          "sops-nix.service"
          "atuin-daemon.service"
        ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${automaticLoginScript}";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  })
  (lib.mkIf isDarwin {
    launchd.agents.atuin-daemon = {
      enable = true;
      config = {
        ProgramArguments = [
          "${atuin}"
          "daemon"
        ];
        EnvironmentVariables = {
          ATUIN_LOG = "info";
        };
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
        ProcessType = "Background";
      };
    };

    launchd.agents.atuin-automatic-login = lib.mkIf automaticLogin {
      enable = true;
      config = {
        ProgramArguments = [ "${automaticLoginScript}" ];
        RunAtLoad = true;
        KeepAlive = false;
        Requires = [
          "org.nix-community.home.sops-nix"
          "org.nix-community.home.atuin-daemon"
        ];
        ProcessType = "Background";
      };
    };
  })
]
