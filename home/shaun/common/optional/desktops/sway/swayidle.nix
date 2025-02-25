{
  config,
  osConfig,
  pkgs,
  ...
}:
{
  services.swayidle = {
    package = pkgs.swayidle;
    enable = true;
    systemdTarget = "graphical-session.target";
    timeouts = [
      {
        timeout = 300;
        command = "${config.programs.swaylock.package}/bin/swaylock -f";
      }
      {
        timeout = 330;
        command = "${osConfig.programs.sway.package}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${osConfig.programs.sway.package}/bin/swaymsg 'output * dpms on'";
      }
      {
        timeout = 1800;
        command = "systemctl suspend";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${config.programs.swaylock.package}/bin/swaylock -f -c 000000";
      }
    ];
  };
}
