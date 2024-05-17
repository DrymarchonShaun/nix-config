{ lib, pkgs, ... }:
{
  services.unbound = {
    enable = lib.mkDefault true;
    package = lib.mkDefault pkgs.unbound-full;
    enableRootTrustAnchor = lib.mkDefault false;
    settings = {
      remote-control.control-enable = true;
      server = {
        tls-system-cert = lib.mkDefault true;
        hide-identity = lib.mkDefault true;
        hide-version = lib.mkDefault true;
        do-not-query-localhost = lib.mkDefault false;
      };
      forward-zone = lib.mkDefault [
        # {
        #  name = "***REMOVED***";
        #  forward-addr = [ "10.1.1.240" ];
        #  forward-first = true;
        # }
        {
          name = ".";
          forward-tls-upstream = true;
          forward-addr = [
            "9.9.9.9#dns.quad9.net"
            "149.112.112.112#dns.quad9.net"
            "2620:fe::fe#dns.quad9.net"
            "2620:fe::9#dns.quad9.net"
          ];
        }
      ];
    };

  };
}
