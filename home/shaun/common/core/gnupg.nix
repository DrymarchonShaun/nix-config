{ pkgs, lib, configLib, configVars, ... }:
let
  update-trust = pkgs.writeShellScript "update-trust" ''
    echo "processing $1"
    KEYID="$(${pkgs.gnupg}/bin/gpg --no-tty --show-keys --keyid-format=long --with-colons "$1" | ${pkgs.gawk}/bin/awk -F ":" 'NR==2 { print $10 }')"
    echo "KEYID is $KEYID"
    echo -e "trust\n5\ny\n" | ${pkgs.gnupg}/bin/gpg -q --command-fd 0 --expert --edit-key "$KEYID"
  '';
in
{
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
  programs.gpg = {
    enable = true;
    # mutableKeys = false;
    # mutableTrust = false;
    publicKeys = [
      {
        source = configLib.relativeToRoot "hosts/common/users/${configVars.username}/keys/gpg/id_odin.asc";
        trust = 5;
      }
    ];
    settings = {
      # Get rid of the copyright notice
      no-greeting = true;

      # Display long key IDs
      keyid-format = "0xlong";
      # List all keys (or the specified ones) along with their fingerprints
      with-fingerprint = true;

      # Display the calculated validity of user IDs during key listings
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity show-keyserver-urls";
    };
  };


  home.activation.importGpgKeys = lib.mkForce (lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" "linkGeneration" "onFilesChange" "setupLaunchAgents" "sops-nix" ] ''
    run ${pkgs.findutils}/bin/find $XDG_RUNTIME_DIR/gpg-keys/ -name "*.asc" -exec ${pkgs.gnupg}/bin/gpg --import {} \; -exec ${pkgs.util-linux}/bin/script -c "${update-trust} {}" \;
  '');
}
