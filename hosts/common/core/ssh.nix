{
  lib,
  pkgs,
  ...
}:
{

  programs.ssh = lib.optionalAttrs pkgs.stdenv.isLinux {
    startAgent = true;
    enableAskPassword = true;
    askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
  };
}
