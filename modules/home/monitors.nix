# The options set using this module are intended for use with logic defined in specific workspace management configurations. For example, see nix-config/home/ta/common/optional/hyprland/
{ lib, config, ... }:
{
  options.monitors = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            example = "DP-1";
          };
          primary = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          noBar = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          width = lib.mkOption {
            type = lib.types.int;
            example = 1920;
          };
          height = lib.mkOption {
            type = lib.types.int;
            example = 1080;
          };
          refreshRate = lib.mkOption {
            type = lib.types.nullOr lib.types.int;
            default = null;
          };
          x = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
          y = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
          scale = lib.mkOption {
            type = lib.types.number;
            default = 1.0;
          };
          transform = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
          enabled = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          #  workspace = lib.mkOption {
          #   type = lib.types.nullOr lib.types.str;
          #   description = "Defines a workspace that should persist on this monitor.";
          #   default = null;
          # };
          workspaces = lib.mkOption {
            type = lib.types.nullOr (lib.types.attrsOf lib.types.str);
            description = "Defines workspaces assigned to this monitor in the form of \"WORKSPACE_ID\"=\"MAIN_KEYBIND\".";
            example = ''
              monitors = [
                {
                  name = "DP-1";
                  ...

                  workspaces = {
                        "1" = "1";
                        "2" = "2";
                        "3" = "3";
                        "4" = "4";
                  };
                }
                {
                  name = "DP-2";
                  ...

                  workspaces = {
                        "11" = "F1";
                        "12" = "F2";
                        "13" = "F3";
                        "14" = "F4";
                  };
                }
              ];
            '';
            default = null;
          };
          vrr = lib.mkOption {
            type = lib.types.int;
            description = "Variable Refresh Rate aka Adaptive Sync aka AMD FreeSync.\nValues are oriented towards hyprland's vrr values which are:\n0 = off, 1 = on, 2 = fullscreen only\nhttps://wiki.hyprland.org/Configuring/Variables/#misc";
            default = 0;
          };

        };
      }
    );
    default = [ ];
  };
  config = {
    assertions = [
      {
        assertion =
          ((lib.length config.monitors) != 0)
          -> ((lib.length (lib.filter (m: m.primary) config.monitors)) == 1);
        message = "Exactly one monitor must be set to primary.";
      }
    ];
  };
}
