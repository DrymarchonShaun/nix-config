{
  pkgs,
  inputs,
  outputs,
  configLib,
  configVars,
  ...
}:
let

  #FIXME: switch this and other isntances to configLib function
  homeDirectory =
    if pkgs.stdenv.isLinux then "/home/${configVars.username}" else "/Users/${configVars.username}";
in
{
  imports =
    (configLib.scanPaths ./.)
    ++ [ inputs.home-manager.nixosModules.home-manager ]
    ++ (builtins.attrValues outputs.nixosModules);

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 20d --keep 20";
    flake = "${homeDirectory}/nix-config";
  };

  # services.yubikey-agent.enable = true;

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
