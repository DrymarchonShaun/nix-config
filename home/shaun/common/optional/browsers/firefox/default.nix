{
  config,
  lib,
  pkgs,
  ...
}:
{
  catppuccin.firefox.profiles = lib.mkForce { };

  # Inspiration:
  # - https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/20
  # - https://github.com/gvolpe/nix-config/blob/6feb7e4f47e74a8e3befd2efb423d9232f522ccd/home/programs/browsers/firefox.nix
  # - https://github.com/lucidph3nx/nixos-config/blob/2e42a40cc8d93c25e01dcbe0dacd8de01f4f0c16/modules/home-manager/firefox/default.nix
  # - https://github.com/Kreyren/nixos-config/blob/bd4765eb802a0371de7291980ce999ccff59d619/nixos/users/kreyren/home/modules/web-browsers/firefox/firefox.nix#L116-L148
  #
  # TODO(firefox):
  # - How to set DDG as default?
  # - Tons of settings above I haven't looked into
  # - Go over existing profiles to add settings
  # - Setup a separate work profile?
  # - Port bookmarks and other profile settings over from existing profile
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) { };

    # Refer to https://mozilla.github.io/policy-templates or `about:policies#documentation` in firefox
    # WARN: Case Sensitive!
    policies = {
      AppAutoUpdate = false; # Disable automatic application update
      BackgroundAppUpdate = false; # Disable automatic application update in the background, when the application is not running.
      DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";
      NoDefaultBookmarks = true;
      DisableBuiltinPDFViewer = false;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = false; # Enable Firefox Sync
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      # OfferToSaveLogins = false; # Managed by Proton
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        # Exceptions = ["https://example.com"]
      };
      HttpsOnlyMode = "force_enabled";
      DNSOverHTTPS = {
        Enabled = true;
        Locked = true;
        ProviderURL = "https://dns.quad9.net/dns-query";
        Fallback = false;
      };
      ExtensionUpdate = true;

      "3rdparty".Extensions = {
        "uBlock0@raymondhill.net" = {
          permissions = [ "internal:privateBrowsingAllowed" ];
        }
        // import ./ublock-origin.nix;
        "addon@darkreader.org" = {
          permissions = [ "internal:privateBrowsingAllowed" ];
        };
        # User agent switcher and manager
        "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" = {
          "json" = builtins.toJSON {
            container-uas = {
              "firefox-container-1" =
                "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/${pkgs.google-chrome.version} Safari/537.36";
            };
            json-forced = true;
          };
        };
      };
      # To copy extensions from an existing profile you can do something like this:
      # cat ~/.mozilla/firefox/fb8sickr.default/extensions.json | jq '.addons[] | [.defaultLocale.name, .id]'
      #
      # To add additional extensions, find it on addons.mozilla.org, find
      # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
      # Then, download the XPI by filling it in to the install_url template, unzip it,
      # run `jq .browser_specific_settings.gecko.id manifest.json` or
      # `jq .applications.gecko.id manifest.json` to get the UUID
      ExtensionSettings =
        (
          let
            extension = shortId: uuid: on_navbar: {
              name = uuid;
              value = {
                install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
                installation_mode = "normal_installed";
                default_area = if on_navbar then "navbar" else "menupanel";
              };
            };
          in
          builtins.listToAttrs [

            (extension "catppuccin-macchiato-blue" "{d49033ac-8969-488c-afb0-5cdb73957f41}" false)
            #TODO Add more of these and test. not high priority though since mozilla sync will pull them in too
            # Development
            #(extension "user-agent-switcher" "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}") # failed

            # Privacy / Security
            (extension "ublock-origin" "uBlock0@raymondhill.net" true)
            (extension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me" true)

            # Layout / Themeing
            (extension "darkreader" "addon@darkreader.org" true)

            # Youtube
            (extension "youtube-addon" "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}" false)
            (extension "dearrow" "deArrow@ajay.app" false)
            (extension "sponsorblock" "sponsorBlocker@ajay.app" false)
            (extension "return-youtube-dislikes" "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" false)

            # Misc
            (extension "auto-tab-discard" "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" false)
            (extension "multi-account-containers" "@testpilot-containers" false)
            (extension "user-agent-string-switcher" "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" false)
            (extension "inde-wiki-buddy" "{cb31ec5d-c49a-4e5a-b240-16c767444f62}" false)
            (extension "augmented-steam" "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}" false)
            (extension "flagfox" "{1018e4d6-728f-4b20-ad56-37578a4de76b}" false)
            (extension "languagetool" "languagetool-webextension@languagetool.org" false)
            (extension "violentmonkey" "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" true)
          ]
        )
        // {
          # FIXME(firefox): Check into how this works
          #"*" = {
          #  installation_mode = "blocked";
          #  blocked_install_message = "blocked extension install";
          #};
        };
    };

    profiles =
      let
        profileDefault = {
          settings = {
            "signon.rememberSignons" = false; # Disable built-in password manager
            "services.passwordSavingEnabled" = false;
            "browser.aboutConfig.showWarning" = false;
            "browser.download.dir" = "${config.xdg.userDirs.download}";
            "browser.urlbar.suggest.quicksuggest.sponsored" = false;
            "browser.tabs.hoverPreview.enabled" = true; # enable new preview tabs feature as of 129.0
            "browser.newtabpage.activity-stream.showSponsored" = "lock-false";
            "browser.newtabpage.activity-stream.system.showSponsored" = "lock-false";
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = "lock-false";
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.feeds.snippets" = "lock-false";
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "browser.download.autohideButton" = false; # never hide downloads button
            "browser.sessionstore.resume_from_crash" = true;
            "media.webrtc.camera.allow-pipewire" = true; # (hopefully) make webcameras work under wayland
            "general.autoScroll" = true;
            "browser.tabs.firefox-view" = true; # Sync tabs across devices
            "browser.tabs.loadInBackground" = true; # load tabs automaticlaly
            "ui.systemUsesDarkTheme" = 1; # force dark theme
            "extensions.pocket.enabled" = false;

            "privacy.resistFingerprinting.block_mozAddonManager" = true;
            "extensions.webextensions.restrictedDomains" = builtins.concatStringsSep "," [
              "accounts-static.cdn.mozilla.net"
              "addons.cdn.mozilla.net"
              "api.accounts.firefox.com"
              "content.cdn.mozilla.net"
              "discovery.addons.mozilla.org"
              "install.mozilla.org"
              "oauth.accounts.firefox.com"
              "profile.accounts.firefox.com"
              "sync.services.mozilla.com"
            ];
          };

          search = {
            force = true;
            default = "Brave Search";
            order = [ "Brave Search" ];
            engines = import ./engines.nix;
          };

          containersForce = true;
          containers = {
            # Container for sites that require a Chrome useragent
            Chrome = {
              name = "Chrome";
              color = "yellow";
              icon = "circle";
              id = 1;
            };
          };
          #
          # This just uses the default suggestion from home-manager for now
          userChrome = ''
            /* Hide tab bar in FF Quantum */
            @-moz-document url("chrome://browser/content/browser.xul") {
              #TabsToolbar {
                visibility: collapse !important;
                margin-bottom: 21px !important;
              }

              #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
                visibility: collapse !important;
              }
            }
          '';
        };
      in
      {
        main = profileDefault // {
          id = 0;
          name = "${config.hostSpec.email.user}";
          isDefault = true;
        };
        school = profileDefault // {
          id = 1;
          name = "${config.hostSpec.email.school}";
        };
      };
  };
  xdg.desktopEntries = {
    firefox-school = {
      categories = [
        "Network"
        "WebBrowser"
      ];
      exec = "firefox -P \"${config.hostSpec.email.school}\" %U";
      icon = "firefox";
      name = "Firefox (School)";
      startupNotify = true;
      terminal = false;
      type = "Application";
    };
  };
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };
}
