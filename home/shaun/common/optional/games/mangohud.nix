{ ... }: {
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      fps = true;
      gamemode = true;
      gpu_stats = true;
      gpu_temp = true;
      no_display = true;
      output_folder = "/home/shaun";
      ram = true;
      resolution = true;
      vram = true;
      vulkan_driver = true;
      wine = true;
    };
  };
}
