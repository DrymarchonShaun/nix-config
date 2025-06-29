{
  writeShellScriptBin,
  lib,
  socat,
  ...
}:
writeShellScriptBin ''ipc-daemon'' ''
    # exec 2> >(logger -p err -t $0)

    function disable-keybind() {
      case $1 in
        # Arma 3 - ACE uses the super key
        activewindow\>\>steam_app_107410,Arma*)
          hyprctl dispatch submap shortcuts-inhibited ;;
          # Helldivers - ???
        # activewindow\>\>steam_app_553850,HELLDIVERS*)
        #   echo "YES $1" && hyprctl dispatch submap shortcuts-inhibited ;;
        activewindow*)
          hyprctl dispatch submap reset ;;
      esac
    }

    handle() {
     case $1 in
      activewindow\>\>*) disable-keybind $1;;
     esac
    }

  ${lib.getExe socat} -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
''
