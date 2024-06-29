{ ... }: {
  imports = [ ./default.nix ];
  virtualisation.oci-containers.containers."openbooks" = {
    image = "evanbuss/openbooks:latest";
    autoStart = true;
    ports = [ "5228:80" ];
    cmd = [
      "--name"
      "${builtins.substring 0 13 (builtins.hashString "sha256" (toString builtins.currentTime))}"
      "--searchbot"
      "searchook"
      "--useragent"
      "Hexchat"
    ];
  };
}
