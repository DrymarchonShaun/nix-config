{
  inputs,
  outputs,
  configLib,
  ...
}:
{
  imports =
    (configLib.scanPaths ./.)
    ++ [ inputs.home-manager.nixosModules.home-manager ]
    ++ (builtins.attrValues outputs.nixosModules);

  #services.yubikey-agent.enable = true;

  # less delay on failed login
  security.pam.services.login = {
    nodelay = true;
    failDelay = {
      enable = true;
      delay = 500000;
    };
  };
  security.pam.services.sudo = {
    nodelay = true;
    failDelay = {
      enable = true;
      delay = 500000;
    };
  };
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=120 # only ask for password every 2h
    # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
    # Defaults env_keep + =SSH_AUTH_SOCK
  '';

  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  nixpkgs = {
    # you can add global overlays here
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableRedistributableFirmware = true;
}
