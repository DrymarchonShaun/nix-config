{ config, ... }:
{
  services.avahi = {
    enable = true;
    domainName = config.hostSpec.domain;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
    denyInterfaces = [
      "podman0"
      "veth@if2"
      "lo"
    ];
  };
}
