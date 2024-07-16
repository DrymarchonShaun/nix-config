{ pkgs, configLib, configVars, ... }: {
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
}
