{ lib, ... }:
let
  inherit (lib.custom.easyeffects)
    getPresets
    profileAutoload
    ;

  inputPresets = getPresets ./input;
  outputPresets = getPresets ./output;
in
{
  imports = [
    # Corais
    (profileAutoload {
      type = "output";
      device = "alsa_output.usb-GuangZhou_FiiO_Electronics_Co._Ltd_FiiO_USB_DAC-E10-00.analog-stereo";
      name = "FiiO USB DAC-E10 Analog Stereo";
      profile = "analog-output";
      preset = "dt990";
    })
    (profileAutoload {
      type = "output";
      device = "alsa_output.pci-0000_0b_00.1.hdmi-stereo";
      name = "Navi 31 HDMI/DP Audio Digital Stereo (HDMI)";
      profile = "hdmi-output-0";
      preset = "none";
    })
    (profileAutoload {
      type = "input";
      device = "alsa_input.usb-Generic_Blue_Microphones_LT_200911141236D70F08DE_111000-00.analog-stereo";
      name = "Blue Microphones Analog Stereo";
      profile = "analog-input-mic";
      preset = "generic";
    })

    # Natrix
    (profileAutoload {
      type = "output";
      device = "alsa_output.pci-0000_00_1f.3.analog-stereo";
      name = "Built-in Audio Analog Stereo";
      profile = "analog-output-headphones";
      preset = "dt990";
    })
    (profileAutoload {
      type = "output";
      device = "alsa_output.pci-0000_00_1f.3.analog-stereo";
      name = "Built-in Audio Analog Stereo";
      profile = "analog-output-speaker";
      preset = "none";
    })
  ];
  services.easyeffects = {
    enable = true;
    extraPresets = builtins.listToAttrs (
      lib.flatten [
        inputPresets
        outputPresets
      ]
    );
  };
}
