{ configVars, ... }:
{
  services.avahi = {
    enable = true;
    domainName = configVars.domain;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
    denyInterfaces = [
      "podman0"
      "veth@if2"
      "lo"
    ];
  };
}
