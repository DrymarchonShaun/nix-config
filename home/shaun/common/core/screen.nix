{ pkgs, config, ... }:
{
  home.packages = [ pkgs.screen ];
  home.sessionVariables = {
    SCREENRC = "${config.home.homeDirectory}/.config/screen/screenrc";
  };
  home.file.".config/screen/screenrc".text = ''
    startup_message off
    defbce on
    setenv TERM xterm-256color
  '';
}
