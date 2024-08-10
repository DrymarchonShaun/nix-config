{ pkgs, ... }:
{
  home.packages = with pkgs; [ wlprop ];
}
