{
  # adminSettings = { };
  userSettings = [
    [
      "advancedUserEnabled"
      "true"
    ]
    [
      "popupPanelSections"
      "31"
    ]
    [
      "cloudStorageEnabled"
      "true"
    ]
    [
      "prefetchingDisabled"
      "true"
    ]
    [
      "hyperlinkAuditingDisabled"
      "true"
    ]
    [
      "cnameUncloakEnabled"
      "true"
    ]
    [
      "autoUpdate"
      "true"
    ]
    [
      "suspendUntilListsAreLoaded"
      "true"
    ]
    [
      "parseAllABPHideFilters"
      "true"
    ]
    # Parse and enforce cosmetic filters
    [
      "ignoreGenericCosmeticFilters"
      "false"
    ]
  ];
  toOverwrite = {
    filterLists = [
      "user-filters"

      # Built-in
      "ublock-filters"
      "ublock-badware"
      "ublock-privacy"
      "ublock-abuse"
      "ublock-quick-fixes"
      "ublock-unbreak"
      "ublock-badlists"

      # Ads
      "easylist"
      "adguard-generic"
      "adguard-mobile"

      # Privacy
      "easyprivacy"
      "adguard-spyware"
      "adguard-spyware-url"
      "block-lan"
      "https://divested.dev/blocklists/Fingerprinting.ubl"

      # Malware protection, security
      "urlhaus-1"
      "curben-phishing"

      # Multipurpose
      "plowe-0"
      "dpollock-0"

      # Cookie notices (replaces istilldontcareaboutcookies)
      "fanboy-cookiemonster"
      "ublock-cookies-easylist"
      "adguard-cookies"
      "ublock-cookies-adguard"

      # Social widgets
      "fanboy-social"
      "adguard-social"
      "fanboy-thirdparty_social"

      # Annoyances
      "easylist-chat"
      "easylist-newsletters"
      "easylist-notifications"
      "easylist-annoyances"
      "adguard-mobile-app-banners"
      "adguard-other-annoyances"
      "adguard-popup-overlays"
      "adguard-widgets"
      "ublock-annoyances"

      # URL Shortener tools (replaces clearurls)
      "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
    ];
    filters = [
      "##body:style(overflow: auto !important)"
      "##html:style(overflow: auto !important)"

      "www.youtube.com##+js(nano-stb, resolve(1), *, 0.001)"
      "www.youtube.com##+js(set, yt.config_.experiment_flags.web_enable_ab_rsp_cl, false)"
      "www.youtube.com##+js(set, yt.config_.experiment_flags.ab_pl_man, false)"
      "||googlevideo.com/videoplayback$xhr,3p,method=get,domain=www.youtube.com"
      # hide member only videos
      "www.youtube.com##:is(ytd-rich-item-renderer,ytd-compact-video-renderer,ytd-video-renderer,ytd-grid-video-renderer):has(.badge-style-type-members-only)"
    ];
    trustedSiteDerectives = [
      "moz-extension-scheme"
    ];
  };
}
