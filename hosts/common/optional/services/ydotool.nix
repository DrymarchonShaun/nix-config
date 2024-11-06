{ configVars, ... }:
{
  users.users.${configVars.username}.extraGroups = [
    "ydotool"
  ];
  programs.ydotool.enable = true;

}
