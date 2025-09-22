{
  pkgs,
  lib,
  extraExtraConfig,
  ...
}:
let
  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    tag = "142.0";
    hash = "sha256-3xvZAMPdGfj8w2AaepWW5xAX05Ry+pN8peLMORKNTIc=";
  };

  ff-ultima = pkgs.fetchFromGitHub {
    owner = "soulhotel";
    repo = "FF-ULTIMA";
    tag = "3.8";
    hash = "sha256-e2Lfs84QmxwQFSk4Da/KpUF3RJ4Xpfx9rqrkYaP2kiU=";
  };
in
{
  userChrome = lib.mkAfter ''@import "${ff-ultima}/userChrome.css";'';
  userContent = lib.mkAfter ''@import "${ff-ultima}/userContent.css";'';
  preConfig = ''
    ${builtins.readFile "${ff-ultima}/user.js"}
  '';

  extraConfig = lib.concatStringsSep "\n" [
    (builtins.readFile "${betterfox}/user.js")
    # SmoothFox
    ''

      /****************************************************************************************
       * OPTION: NATURAL SMOOTH SCROLLING V3 [MODIFIED]                                      *
      ****************************************************************************************/
      // credit: https://github.com/AveYo/fox/blob/cf56d1194f4e5958169f9cf335cd175daa48d349/Natural%20Smooth%20Scrolling%20for%20user.js
      // recommended for 120hz+ displays
      // largely matches Chrome flags: Windows Scrolling Personality and Smooth Scrolling
      user_pref("apz.overscroll.enabled", true); // DEFAULT NON-LINUX
      user_pref("general.smoothScroll", true); // DEFAULT
      user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 12);
      user_pref("general.smoothScroll.msdPhysics.enabled", true);
      user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 600);
      user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 650);
      user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 25);
      user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio", "2");
      user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 250);
      user_pref("general.smoothScroll.currentVelocityWeighting", "1");
      user_pref("general.smoothScroll.stopDecelerationWeighting", "1");
      user_pref("mousewheel.default.delta_multiplier_y", 250); // 250-400; adjust this number to your liking
    ''

    # Ultima settings
    ''
      user_pref("ultima.disable.windowcontrols.button", true);
    ''

    extraExtraConfig
  ];
}
