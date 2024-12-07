{ config, ... }:
{
  home.sessionVariables = {
    MANGOHUD_CONFIGFILE = "${config.home.homeDirectory}/${
      config.xdg.configFile."MangoHud/MangoHud.conf".target
    }";
  };
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      cpu_power = true;
      fps = true;
      gamemode = true;
      gpu_power = true;
      gpu_stats = true;
      gpu_temp = true;
      mangoapp_steam = true;
      no_display = true;
      output_folder = config.home.homeDirectory;
      ram = true;
      resolution = true;
      toggle_hud = "Super_R";
      vram = true;
      vulkan_driver = true;
      wine = true;
    };
  };
}
