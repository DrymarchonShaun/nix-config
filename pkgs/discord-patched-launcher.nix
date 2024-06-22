{ stdenv
, writers
, python3Packages
, coreutils
, libnotify
, discord
, dev
, killall
, makeDesktopItem
, writeShellApplication
}:
stdenv.mkDerivation
rec {
  name = "discord";
  buildCommand =
    let
      discord-patcher-launcher =
        let

          # uncomment when vencord is broken
          # vencord = discord;
          vencord = discord.override { withVencord = true; vencord = dev.vencord; };

          krisp-patcher = writers.writePython3Bin "krisp-patcher"
            {
              libraries = with python3Packages; [ capstone pyelftools ];
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
        in
        writeShellApplication {
          inherit name;
          text = ''
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
                  krisp-patcher "$(realpath ~/.config/discord/${vencord.version}/modules/discord_krisp/discord_krisp.node)"
                  ${vencord}/bin/discord
                    break
                fi
              done
          '';
          runtimeInputs = [
            libnotify
            krisp-patcher
            coreutils
            killall
          ];
        };
      desktopItem = makeDesktopItem {
        name = "discord";
        exec = "discord";
        icon = "discord";
        desktopName = "Discord";
        genericName = "All-in-one cross-platform voice and text chat for gamers";
        categories = [ "Network" "InstantMessaging" ];
        mimeTypes = [ "x-scheme-handler/discord" ];
      };
    in
    ''
      install -Dm755 ${discord-patcher-launcher}/bin/discord $out/bin/discord
      install -Dm755 ${desktopItem}/share/applications/discord.desktop $out/share/applications/discord.desktop
    '';
  dontBuild = true;
}
