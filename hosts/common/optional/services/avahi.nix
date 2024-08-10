{ ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    denyInterfaces = [
      "podman0"
      "veth@if2"
      "lo"
    ];
  };
}
