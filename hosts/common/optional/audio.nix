{ pkgs, config, ... }:
let
  quantum = {
    def = 512;
    min = 256;
    max = 2048;
  };
  rate = 48000;
in
{

  users.users.${config.hostSpec.username}.extraGroups = [
    "pipewire"
    "audio"
  ];

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      pwvucontrol # pipewire volume control
      qpwgraph # pipewire plugboard
      playerctl # cli utility and lib for controlling media players
      ;
  };

  # sound.enable = true; #deprecated in 24.11 TODO remove this line when 24.11 release
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
    extraConfig = {
      pipewire = {
        "92-quantum" = {
          "context.properties" = {
            "default.clock.rate" = rate;
            "default.clock.quantum" = quantum.def;
            "default.clock.min-quantum" = quantum.min;
            "default.clock.max-quantum" = quantum.max;
          };
        };
      };
      pipewire-pulse = {
        "92-low-latency" = {
          context.modules = [
            {
              name = "libpipewire-module-rtkit";
              args = {
                nice.level = -15;
                rt.prio = 88;
                rt.time.soft = 200000;
                rt.time.hard = 200000;
              };
              flags = [
                "ifexists"
                "nofail"
              ];
            }
            {
              name = "libpipewire-module-protocol-pulse";
              args = {
                pulse.min.req = "${toString quantum.min}/${toString rate}";
                pulse.default.req = "${toString quantum.min}/${toString rate}";
                pulse.max.req = "${toString quantum.min}/${toString rate}";
                pulse.min.quantum = "${toString quantum.min}/${toString rate}";
                pulse.max.quantum = "${toString quantum.min}/${toString rate}";
                server.address = [ "unix:native" ];
              };
            }
          ];
          stream.properties = {
            node.latency = "${toString quantum.min}/${toString rate}";
            resample.quality = 1;
          };
        };
      };
    };
    wireplumber.extraConfig."92-low-latency" = {
      "monitor.alsa.rules" = [
        {
          matches = [ { "device.name" = "~alsa_card.*"; } ];
          actions = {
            update-props = {
              "audio.format" = "S32LE";
              "audio.rate" = "${toString (rate * 2)}";
              "api.alsa.period-size" = 2;
              "api.alsa.disable-batch" = false;
            };
          };
        }
      ];
    };

  };
}
