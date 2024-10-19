{ pkgs, ... }:
let
  fir = pkgs.stdenv.mkDerivation {
    name = "fir";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "GICodeWarrior";
      repo = "fir";
      rev = "master";
      sha256 = "sha256-dDnihx+tj2HGF7nZ9u47KSvyyOpTaX3mXo3Wi2dbmH4=";
    };
    installPhase = ''
      mkdir -p $out/opt/
      cp -r $src $out/opt/fir
    '';
  };
in
{
  imports = [
    ./default.nix
    ./networks/local.nix
  ];
  virtualisation.oci-containers.containers."foxhole-inventory-report" = {
    image = "foxhole-inventory-report:latest";
    imageFile = pkgs.dockerTools.buildImage {
      name = "foxhole-inventory-report";
      tag = "latest";
      copyToRoot = pkgs.buildEnv {
        name = "fir-image-root";
        paths = [
          pkgs.python3
          fir
        ];
        pathsToLink = [
          "/bin"
          "/opt"
        ];
      };
      config = {
        WorkingDir = "/opt/fir/";
        Cmd = [
          "python3"
          "-m"
          "http.server"
        ];
      };
    };
    autoStart = true;
    extraOptions = [
      "--network=localnet"
      "--ip=11.0.0.2"
    ];
    dependsOn = [ "network-local" ];
    # ports = [ "6855:8000" ];
  };
}
