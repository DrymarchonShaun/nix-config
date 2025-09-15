{ pkgs, ... }:
let
  touchpad-toggle = pkgs.writeShellScript "" ''
    HYPRLAND_DEVICE="elan0412:00-04f3:3240-touchpad"
    HYPRLAND_VARIABLE="device[$HYPRLAND_DEVICE]:enabled"

    if [ -z "$XDG_RUNTIME_DIR" ]; then
      export XDG_RUNTIME_DIR=/run/user/$(id -u)
    fi

    export STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

    enable_touchpad() {
        printf "true" >"$STATUS_FILE"
    hyprctl keyword $HYPRLAND_VARIABLE "true" -r
    }

    disable_touchpad() {
        printf "false" >"$STATUS_FILE"
    hyprctl keyword $HYPRLAND_VARIABLE "false" -r
    }

    if ! [ -f "$STATUS_FILE" ]; then
      disable_touchpad
    else
      if [ $(cat "$STATUS_FILE") = "true" ]; then
        disable_touchpad
      elif [ $(cat "$STATUS_FILE") = "false" ]; then
        enable_touchpad
      fi
    fi
  '';
in
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/browsers
    common/optional/desktops/hyprland
    common/optional/desktops/rofi.nix
    common/optional/desktops/common/ghostty.nix
    common/optional/development
    common/optional/comms
    common/optional/gaming
    common/optional/media
    common/optional/tools

    common/optional/atuin.nix
    common/optional/xdg.nix # file associations
    common/optional/sops.nix
  ];

  programs.hyprpanel.hasBattery = true;
  wayland.windowManager.hyprland.settings.bindl = [
    ",switch:Lid Switch,exec,pidof hyprlock || hyprlock"
  ];

  wayland.windowManager.hyprland.settings.bind = [
    ",XF86TouchpadToggle,exec,${touchpad-toggle}"
  ];

}
