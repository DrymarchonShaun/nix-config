{ ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/development
    common/optional/tools
    common/optional/atuin.nix
    common/optional/xdg.nix # file associations
    common/optional/sops.nix
  ];

  #
  # ========== Host-specific Monitor Spec ==========
  #
  # This uses the nix-config/modules/home-manager/montiors.nix module which defaults to enabled.
  # Your nix-config/home-manger/<user>/common/optional/desktops/foo.nix WM config should parse and apply these values to it's monitor settings
  # If on hyprland, use `hyprctl monitors` to get monitor info.
  # https://wiki.hyprland.org/Configuring/Monitors/

  monitors = [
    {
      name = "HEADLESS-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      scale = 1.0;
      x = 0;
      primary = true;
    }
  ];

}
