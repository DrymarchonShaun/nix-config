{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      wl-clipboard
      xclip
      ;
  };
  #services.cliphist = {
  #  enable = true;
  #  allowImages = true;
  #};
  services.copyq = {
    enable = true;
  };
}
