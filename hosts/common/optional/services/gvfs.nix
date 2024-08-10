{ ... }:
{
  #### passwordless mounting ####
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  users.groups.storage = { };
}
