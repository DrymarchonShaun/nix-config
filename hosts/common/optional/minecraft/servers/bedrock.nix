{
  pkgs,
  config,
  ...
}:
{
  enable = true;
  package = pkgs.fabricServers.fabric-1_21_4;
  autoStart = true;
  restart = "always";
  serverProperties = {
    server-port = (config.hostSpec.networking.ports.minecraft + 10);
    difficulty = "normal";
    view-distance = 16;
  };

  jvmOpts = "-Xmx4G";

  symlinks = {
    "mods/better-fabric-console.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/Y8o1j1Sf/versions/3d1g5aTY/better-fabric-console-mc1.21.4-1.2.2.jar";
      sha512 = "aa7ea5e6fad06927462655331985e58d270bf2f6ac31a9c685830e8d4249c6a3de51f2a2e63ddef150432040448926c3238d3bab4722a26733c5e7db64359563";
    };
    "mods/fabric-api.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/HbTXYTBz/fabric-api-0.119.0%2B1.21.4.jar";
      sha512 = "f2e44507dcf7c34ac5104bf78c0f0f0ab99840272d0c1afc51236b7f8a56541bd5c2024953a83599034e1b55191e38b3e437b6b80736137e2ee4d7d571f42c82";
    };
    "mods/floodgate.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/bWrNNfkb/versions/nyg969vQ/Floodgate-Fabric-2.2.4-b43.jar";
      sha512 = "0d73f7f88429f15989b0e7a33f05c2812d13822fd50e4c1a1793c9e2e65abbbe19cb2ad6bb9a6328e076cadf531261e893a88666be7efbc1b6d7f9534e52b336";
    };
    "mods/geyser.jar" = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/iKPNjCpK/geyser-fabric-Geyser-Fabric-2.6.1-b786.jar";
      sha512 = "3be964709e65d68352a9dc1a52ad8626c8ea11ae9061e06e9570f0702e09602b1e25d9e608f882509735d4220c6e296418345b810aff231661056de65292a1a0";
    };
  };
}
