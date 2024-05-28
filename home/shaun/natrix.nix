{ lib, configVars, ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/sops.nix
    common/optional/browsers/brave.nix
    common/optional/comms/discord.nix
    common/optional/dev/vscode.nix
    common/optional/games/steam.nix
    common/optional/games/heroic.nix
    common/optional/media/calibre.nix
    common/optional/tools/eye-of-gnome.nix
    common/optional/tools/gimp.nix
    common/optional/tools/inkscape.nix
    common/optional/tools/libreoffice.nix
    common/optional/tools/wine.nix
    common/optional/tools/mime.nix
    common/optional/tools/nemo.nix

    common/optional/desktops

  ];

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };
  # Disable impermanence
  #home.persistence = lib.mkForce { };

}
