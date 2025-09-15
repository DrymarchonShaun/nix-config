{ ... }:
{
  #
  # ========== Host-specific Monitor Spec ==========
  #
  # This uses the nix-config/modules/home-manager/montiors.nix module which defaults to enabled.
  # Your nix-config/home-manger/<user>/common/optional/desktops/foo.nix WM config should parse and apply these values to it's monitor settings
  monitors = [
    {
      name = "eDP-1";

      width = 1920;
      height = 1080;
      refreshRate = 60;

      x = 0;
      y = 0;
      scale = 1;

      noBar = false;
      primary = true;
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
      name = "HDMI-A-1";

      width = 1920;
      height = 1080;
      refreshRate = 60;

      x = 1920;
      y = 0;
      scale = 1;

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
