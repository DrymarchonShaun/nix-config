{
  userSettings = [
    [
      "advancedUserEnabled"
      true
    ]
    [
      "popupPanelSections"
      31
    ]
  ];
  toOverwrite = {
    filterLists = [
      "user-filters"
      "ublock-filters"
      "ublock-badware"
      "ublock-privacy"
      "ublock-quick-fixes"
      "ublock-unbreak"
      "easylist"
      "easyprivacy"
      "urlhaus-1"
      "plowe-0"
      "fanboy-cookiemonster"
      "ublock-cookies-easylist"
      "ublock-annoyances"
    ];
    externalLists = [
      "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
    ];
    importedLists = [
      "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
    ];
    trustedSiteDerectives = [
      "about-scheme"
      "moz-extension-scheme"
    ];
  };
  toAdd = {
    userFilters = builtins.concatStringsSep "\n" [
      "##body:style(overflow: auto !important)"
      "##html:style(overflow: auto !important)"
      "www.youtube.com##+js(nano-stb, resolve(1), *, 0.001)"
      "www.youtube.com##+js(set, yt.config_.EXPERIMENT_FLAGS.web_enable_ab_rsp_cl, false)"
      "www.youtube.com##+js(set, yt.config_.EXPERIMENT_FLAGS.ab_pl_man, false)"
      "||googlevideo.com/videoplayback$xhr,3p,method=get,domain=www.youtube.com"

      "! Dec 7, 2024 https://en.wikipedia.org"
      "en.wikipedia.org##.cn-fundraising"
    ];
    dynamicFilteringString = builtins.concatStringsSep "\n" [
      "no-csp-reports: * true"
      "no-large-media: behind-the-scene false"
      "behind-the-scene * * noop"
      "behind-the-scene * 1p-script noop"
      "behind-the-scene * 3p noop"
      "behind-the-scene * 3p-frame noop"
      "behind-the-scene * 3p-script noop"
      "behind-the-scene * image noop"
      "behind-the-scene * inline-script noop"
    ];
  };
}
