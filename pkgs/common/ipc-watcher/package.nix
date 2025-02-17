{
  writeShellScript,
  lib,
  socat,
  ...
}:
writeShellScript ''ipc-watcher'' ''

    function disable-keybind() {
      case $1 in
        activewindow\>\>steam_app_107410,Arma*)
          echo "YES $1" && hyprctl dispatch submap shortcuts-inhibited ;;
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
