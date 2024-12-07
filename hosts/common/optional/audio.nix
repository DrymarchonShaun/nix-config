{ pkgs, config, ... }:
let
  quantum = {
    def = 256;
    min = 256;
    max = 512;
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
      pamixer # pulseaudio sound mixer
      pwvucontrol # pipewire volume control
      qpwgraph # pipewire plugboard
      playerctl # cli utility and lib for controlling media players
      ;
  };

  # sound.enable = true; #deprecated in 24.11 TODO remove this line when 24.11 release
  hardware.pulseaudio.enable = false;
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
        "99-rnnoise" = {
          "context.modules" = [
            {
              name = "libpipewire-module-filter-chain";
              args = {
                "node.description" = "Noise Canceling source";
                "media.name" = "Noise Canceling source";

                "filter.graph" = {
                  nodes = [
                    {
                      type = "ladspa";
                      name = "rnnoise";
                      plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                      label = "noise_suppressor_mono";
                      control = {
                        "VAD Threshold (%)" = 60.0;
                        "VAD Grace Period (ms)" = 200;
                        "Retroactive VAD Grace (ms)" = 0;
                      };
                    }
                  ];
                };

                "capture.props" = {
                  "node.name" = "capture.rnnoise_source";
                  "node.passive" = true;
                  "audio.rate" = rate;
                };

                "playback.props" = {
                  "node.name" = "rnnoise_source";
                  "media.class" = "Audio/Source";
                  "audio.rate" = rate;
                };
              };
            }
          ];
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
