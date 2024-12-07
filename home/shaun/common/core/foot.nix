{ ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrains Mono:size=12,Symbols Nerd Font Mono:size=12";
      };

      bell = {
        urgent = "no";
        notify = "no";
        command-focused = "no";
      };

      scrollback = {
        lines = 10000;
      };
      url = {
        launch = "xdg-open \${url}";
        protocols = "http, https, ftp, ftps, file, gemini, gopher, steam, ssh";
      };
      colors = {
        alpha = 0.6;
      };
    };
  };
}
