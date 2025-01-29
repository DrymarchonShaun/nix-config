{ ... }:
{
  # users.users.${configVars.username}.extraGroups = [
  #  "podman"
  # ];
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      autoPrune.enable = true;
    };
  };
}
