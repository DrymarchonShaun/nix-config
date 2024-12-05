{ configVars, ... }:
{
  users.users.${configVars.username}.extraGroups = [
    "adbusers"
  ];
  programs.adb.enable = true;

}
