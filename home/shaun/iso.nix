{ lib, ... }:
{
  imports = [
    common/core
  ];
  programs.zsh.generateCompletions = lib.mkForce false;
  programs.zsh.generateSystemCompletions = lib.mkForce false;
}
