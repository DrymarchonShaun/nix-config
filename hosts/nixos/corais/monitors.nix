{ ... }:
{
  #
  # ========== Host-specific Monitor Spec ==========
  #
  # This uses the nix-config/modules/home-manager/montiors.nix module which defaults to enabled.
  # Your nix-config/home-manger/<user>/common/optional/desktops/foo.nix WM config should parse and apply these values to it's monitor settings
  # If on hyprland, use `hyprctl monitors` to get monitor info.
  # https://wiki.hyprland.org/Configuring/Monitors/
  #  ------   ------
  # | DP-1 | | DP-2 |
  #  ------   ------
  monitors = [
    {
      name = "DP-1";

      width = 2560;
      height = 1440;
      refreshRate = 165;

      x = 0;
      y = 0;
      scale = 1.0;

      vrr = 0;
      primary = true;
      noBar = false;

      workspaces = {
        "1" = "1";
        "2" = "2";
        "3" = "3";
        "4" = "4";
        "5" = "5";
        "6" = "6";
        "7" = "7";
        "8" = "8";
        "9" = "9";
        "10" = "0";
      };
    }
    {
      name = "DP-2";

      width = 2560;
      height = 1440;
      refreshRate = 165;

      x = 2560;
      y = 0;
      scale = 1.0;

      vrr = 0;

      workspaces = {
        "11" = "F1";
        "12" = "F2";
        "13" = "F3";
        "14" = "F4";
        "15" = "F5";
        "16" = "F6";
        "17" = "F7";
        "18" = "F8";
        "19" = "F9";
        "20" = "F10";
        "21" = "F11";
        "22" = "F12";
      };
    }
  ];

}
