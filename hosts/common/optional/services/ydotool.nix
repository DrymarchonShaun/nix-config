{ config, ... }:
{
  users.users.${config.hostSpec.username}.extraGroups = [
    "ydotool"
  ];
  programs.ydotool.enable = true;

}
