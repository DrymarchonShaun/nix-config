{ pkgs, lib, configLib, configVars, ... }: {
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
  programs.gpg = {
    publicKeys = [
      {
        source = configLib.relativeToRoot "hosts/common/users/${configVars.username}/keys/gpg/id_odin.asc";
        trust = 5;
      }
    ];
  };
  home.activation.importGpgKeys = lib.mkForce (lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" "linkGeneration" "onFilesChange" "setupLaunchAgents" "sops-nix" ] ''
    run ${pkgs.findutils}/bin/find $XDG_RUNTIME_DIR/gpg-keys/ -name "*.asc" -exec ${pkgs.gnupg}/bin/gpg --import {} \;
  '');
}
