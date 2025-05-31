{
  writeShellScriptBin,
  lib,
  socat,
  ...
}:
writeShellScriptBin ''ipc-daemon'' ''
    exec 1> >(logger -t $0) && exec 2> >(logger -p err -t $0) && exec 5> >(logger -p debug -t $0) && BASH_XTRACEFD="5" PS4='$LINENO: '

    function disable-keybind() {
      case $1 in
        # Arma 3 - ACE uses the super key
        activewindow\>\>steam_app_107410,Arma*)
          echo "YES $1" && hyprctl dispatch submap shortcuts-inhibited ;;
          # Helldivers - ???
        # activewindow\>\>steam_app_553850,HELLDIVERS*)
        #   echo "YES $1" && hyprctl dispatch submap shortcuts-inhibited ;;
        activewindow*)
          echo "NO $1" && hyprctl dispatch submap reset ;;
      esac
    }

    handle() {
     case $1 in
      activewindow\>\>*) disable-keybind $1;;
     esac
    }

  ${lib.getExe socat} -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
''
