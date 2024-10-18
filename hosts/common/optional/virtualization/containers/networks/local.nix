{ pkgs, ... }:
{
  # Networks
  systemd.services."podman-network-local" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.podman}/bin/podman network rm -f localnet";
    };
    script = ''
      podman network inspect localnet || podman network create --internal localnet --subnet 11.0.0.0/24

    '';
  };
}
