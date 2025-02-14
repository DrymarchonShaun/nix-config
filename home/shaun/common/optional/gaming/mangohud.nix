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
      background_alpha = 0.5;
      cpu_power = true;
      cpu_stats = true;
      display_server = true;
      font_size = 24;
      fps = true;
      frame_timing = true;
      gamemode = true;
      gpu_junction_temp = true;
      gpu_power = true;
      gpu_stats = true;
      gpu_temp = true;
      mangoapp_steam = true;
      no_display = true;
      output_folder = config.home.homeDirectory;
      ram = true;
      resolution = true;
      round_corners = 0;
      table_columns = 3;
      # toggle_hud = "Super_R";
      vram = true;
      vulkan_driver = true;
      wine = true;
    };
  };
}
