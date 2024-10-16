{
  stdenv,
  writers,
  fetchurl,
  python3Packages,
  coreutils,
  libnotify,
  discord,
  master,
  killall,
  makeDesktopItem,
  writeShellApplication,
}:
stdenv.mkDerivation rec {
  name = "discord";
  buildCommand =
    let
      discord-patcher-launcher =
        let

          # uncomment when vencord is broken
          # vencord = discord;
          vencord = discord.override {
            withVencord = true;
            vencord = master.vencord;
          };

          krisp-patcher =
            writers.writePython3Bin "krisp-patcher"
              {
                libraries = builtins.attrValues {
                  inherit (python3Packages)
                    capstone
                    pyelftools
                    ;
                };
                flakeIgnore = [
                  "E501" # line too long (82 > 79 characters)
                  "F403" # ‘from module import *’ used; unable to detect undefined names
                  "F405" # name may be undefined, or defined from star imports: module
                ];
              }
              (fetchurl {
                # url = "https://raw.githubusercontent.com/sersorrel/sys/de1ce2ba941318a05d4d029f717ad8be7b4b09ee/hm/discord/krisp-patcher.py";
                url = "https://raw.githubusercontent.com/sersorrel/sys/main/hm/discord/krisp-patcher.py";
                sha256 = "sha256-h8Jjd9ZQBjtO3xbnYuxUsDctGEMFUB5hzR/QOQ71j/E=";
              });
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
        categories = [
          "Network"
          "InstantMessaging"
        ];
        mimeTypes = [ "x-scheme-handler/discord" ];
      };
    in
    ''
      install -Dm755 ${discord-patcher-launcher}/bin/discord $out/bin/discord
      install -Dm755 ${desktopItem}/share/applications/discord.desktop $out/share/applications/discord.desktop
    '';
  dontBuild = true;
}
