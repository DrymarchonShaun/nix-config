{ pkgs, ... }:
let
  vencord = pkgs.discord.override { withVencord = true; };
  krisp-patcher = pkgs.writers.writePython3Bin "krisp-patcher"
    {
      libraries = with pkgs.python3Packages; [ capstone pyelftools ];
      flakeIgnore = [
        "E501" # line too long (82 > 79 characters)
        "F403" # ‘from module import *’ used; unable to detect undefined names
        "F405" # name may be undefined, or defined from star imports: module
      ];
    }
    (builtins.readFile (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/sersorrel/sys/main/hm/discord/krisp-patcher.py";
      sha256 = "sha256-87VlZKw6QoXgQwEgxT3XeFY8gGoTDWIopGLOEdXkkjE=";
    }));

  discord-patched-launch = pkgs.writeScriptBin "discord" ''
    while true; do
      if [ ! -f ~/.config/discord/${vencord.version}/modules/discord_krisp/discord_krisp.node ]; then
        ${vencord}/bin/discord &
        notify-send "Failed to Apply Patch - Relaunching Discord" "File /modules/discord_krisp/discord_krisp.node does not exist"
        
        # Wait for the file to appear
        while [ ! -f ~/.config/discord/${vencord.version}/modules/discord_krisp/discord_krisp.node ]; do
          sleep 1
        done
        
        # Kill Discord process
        killall .Discord-wrapped
      else
        ${krisp-patcher}/bin/krisp-patcher "$(realpath ~/.config/discord/${vencord.version}/modules/discord_krisp/discord_krisp.node)"
        ${vencord}/bin/discord
          break
      fi
    done
  '';
in
{
  home.packages = [ discord-patched-launch ];
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
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      ExecStart = "${discord-patched-launch}/bin/discord";
      KillMode = "mixed";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
