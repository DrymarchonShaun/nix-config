{ ... }: {
  virtualisation.oci-containers.containers."openbooks" = {
      image = "evanbuss/openbooks:latest";
      autoStart = true;
      ports = [ "5228:80" ];
      cmd = [ "--name" "Drymarchon" "--searchbot" "searchook" "--useragent" "Hexchat" ];
    };
}
