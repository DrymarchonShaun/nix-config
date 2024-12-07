{ config, ... }:
{
  users.users.${config.hostSpec.username}.extraGroups = [
    "adbusers"
  ];
  programs.adb.enable = true;

}
