{ pkgs, ... }:
let
  discord-wayland = (pkgs.unstable.discord.overrideAttrs (
    old: {
      # nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
      # postFixup = (old.postFixup or "") + ''
      #   wrapProgram $out/bin/discord \
      #     --add-flags "--enable-features=UseOzonePlatform" \
      #     --add-flags "--ozone-platform=wayland"
      # '';
    }
  )).override { withVencord = true; };

  krisp-patcher = pkgs.writers.writePython3Bin "krisp-patcher"
    {
      libraries = with pkgs.python3Packages; [ capstone pyelftools ];
      flakeIgnore = [
        "E501" # line too long (82 > 79 characters)
        "F403" # ‘from module import *’ used; unable to detect undefined names
        "F405" # name may be undefined, or defined from star imports: module
      ];
    }
    (builtins.readFile (pkgs.fetchFromGitHub
      {
        owner = "sersorrel";
        repo = "sys";
        rev = "main";
        sha256 = "sha256-lRkQ1VXOz13Edn53Gn1SwcqVjZkjwGCIIBvvENBLe7Y=";
      } + "/hm/discord/krisp-patcher.py"));
in
{
  home.packages = [
    discord-wayland
    krisp-patcher
  ];
  # home.packages = [ discord-wayland ];
  systemd.user.services.discord = {
    Unit = {
      StartLimitBurst = 30;
      Description =
        "Autostart Discord in Sway";
      Requires = [ "tray.target" ];
      After = [ "graphical-session-pre.target" "tray.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      RestartSec = 5;
      Restart = "on-failure";
      ExecStart = "/bin/sh -c \"${pkgs.coreutils}/bin/sleep 5 && ${discord-wayland}/bin/discord\"";
      KillMode = "mixed";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
