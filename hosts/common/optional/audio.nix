{ pkgs, ... }:
{
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

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      pamixer # pulseaudio sound mixer
      # pavucontrol # replaced with pwvucontrol
      pwvucontrol # pipewire volume control
      qpwgraph # pipewire plugboard
      playerctl # cli utility and lib for controlling media players
      # pamixer # cli pulseaudio sound mixer
      ;
  };

  services.pipewire.extraConfig.pipewire."99-rnnoise" = {
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
            "audio.rate" = 48000;
          };

          "playback.props" = {
            "node.name" = "rnnoise_source";
            "media.class" = "Audio/Source";
            "audio.rate" = 48000;
          };
        };
      }
    ];
  };
}
