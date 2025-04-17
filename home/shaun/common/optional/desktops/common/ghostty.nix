{ ... }:
{
  programs.ghostty = {
    enable = true;

    enableFishIntegration = true;

    settings = {
      theme = "catppuccin-macchiato";
      window-decoration = false;
      background-opacity = 0.6;
      keybind = [
        "ctrl+enter=unbind"
      ];
    };
  };
}
