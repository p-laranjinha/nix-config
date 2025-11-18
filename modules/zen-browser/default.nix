{
  pkgs,
  config,
  inputs,
  ...
}: {
  hm = {
    imports = [
      inputs.zen-browser.homeModules.beta
    ];

    # Makes bookmarks look like essentials.
    home.file.".zen/default/chrome/userChrome.css".source = config.lib.meta.mkMutableConfigSymlink ./zen-browser-clean-bookmarks.css;

    programs.zen-browser = {
      enable = true;

      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never"; # "never" "always" "newtab"
        DisplayMenuBar = "default-off"; # "default-off" "always" "never" "default-on"
        SearchBar = "unified"; # "unified" "separate"
        NoDefaultBookmarks = true;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
      };
      profiles.default = {
        settings = {
          # Makes extensions store things in files instead of in IndexedDB.
          # Extensions that aren't synced between devices store their settings here.
          # IndexedDB supposedly improves performance but doesn't allow me to
          #  declaratively set extension settings.
          # But I don't feel like declaring the settings for the few extensions that
          #  aren't synced, and the performance hit might not be worth it.
          "extensions.webextensions.ExtensionStorageIDB.enabled" = true;

          "browser.tabs.closeWindowWithLastTab" = false;
          "privacy.donottrackheader.enabled" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          "browser.urlbar.maxRichResults" = 15;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.search.separatePrivateDefault" = false;
          "browser.newtabpage.pinned" = []; # Removes "Search with Google" from search results
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.tabs.loadBookmarksInTabs" = true;
          "browser.urlbar.openintab" = true;

          # https://docs.zen-browser.app/guides/live-editing
          # Required to see the devtools for the browser UI and for userChrome.css to work.
          "devtools.debugger.remote-enabled" = true;
          "devtools.chrome.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          "zen.tabs.show-newtab-vertical" = false;
          "zen.urlbar.behavior" = "float";
          "zen.splitView.change-on-hover" = true;
          "zen.theme.accent-color" = "#aac7ff"; # The first blue option
          "zen.urlbar.replace-newtab" = true; # Set this to false to go back to regular new tab
          "zen.tab-unloader.enabled" = false;
          "zen.urlbar.show-protections-icon" = true;

          "browser.uiCustomization.state" = builtins.toJSON {
            placements = {
              widget-overflow-fixed-list = [
              ];
              nav-bar = [
                "back-button"
                "stop-reload-button"
                "forward-button"
                "urlbar-container"
                "unified-extensions-button"
              ];
              toolbar-menubar = [
                # No idea what this does.
                "menubar-items"
              ];
              TabsToolbar = [
                "personal-bookmarks"
                "tabbrowser-tabs"
              ];
              vertical-tabs = [];
              PersonalToolbar = [];
              zen-sidebar-top-buttons = [];
              zen-sidebar-foot-buttons = [
                "preferences-button"
                "zen-workspaces-button"
                "downloads-button"
                "sidebar-button"
              ];
              # Some extensions may appear in the nav-bar if they're not here.
              # The extensions appear in this order.
              unified-extensions-area = [
                "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action" # Bitwarden
                "addon_darkreader_org-browser-action" # Dark Reader
                "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action" # Violentmonkey
                "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action" # Stylus
                "_d07ccf11-c0cd-4938-a265-2a4d6ad01189_-browser-action" # Web Archives
                "ublock0_raymondhill_net-browser-action" # uBlock Origin
                "_5d554479-7cc4-487f-bd25-d8fc67a42602_-browser-action" # FMHY SafeGuard
                "gdpr_cavi_au_dk-browser-action" # Consent-O-Matic
                "dearrow_ajay_app-browser-action" # DeArrow
                "sponsorblocker_ajay_app-browser-action" # SponsorBlock
                "enhancerforyoutube_maximerf_addons_mozilla_org-browser-action" # Enhancer for Youtube
                "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action" # Return Youtube Dislike
                "_59c55aed-bdb3-4f2f-b81d-27011a689be6_-browser-action" # YouTube Windowed FullScreen
                "_a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad_-browser-action" # Refined GitHub
                "_036a55b4-5e72-4d05-a06c-cba2dfcc134a_-browser-action" # TWP - Translate Web Pages
                "default-bookmark-folder_gustiaux_com-browser-action" # Default Bookmark Folder
              ];
            };
            seen = [];
            dirtyAreaCache = [];
            # This has to be bigger than the "currentVersion" in about:config or prefs.js.
            "currentVersion" = 999;
            "newElementCount" = 0;
          };
        };
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          ublock-origin
          darkreader
          # The rest can just be installed by logging in to the Firefox account.
        ];
        search = {
          force = true;
          default = "Searxng";
          order = [
            "Searxng"
            "ddg"
            "google"
          ];
          # https://searchfox.org/firefox-main/rev/b7497e2adf09e8b17bf161df07945f42c9f8cfe5/toolkit/components/search/SearchEngine.sys.mjs#890-923
          engines = {
            "Searxng" = {
              urls = [
                {template = "http://localhost:8080/search?q={searchTerms}";}
                {
                  template = "http://localhost:8080/autocompleter?q={searchTerms}";
                  # https://searchfox.org/firefox-main/rev/b7497e2adf09e8b17bf161df07945f42c9f8cfe5/toolkit/components/search/SearchUtils.sys.mjs#162-168
                  type = "application/x-suggestions+json";
                }
              ];
              updateInterval = 24 * 60 * 60 * 1000; # every day
              icon = "https://docs.searxng.org/_static/searxng-wordmark.svg";
              definedAliases = ["@s"];
            };
            "Nix Packages" = {
              urls = [{template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";}];
              updateInterval = 24 * 60 * 60 * 1000; # every day
              icon = "https://search.nixos.org/favicon-96x96.png";
              definedAliases = ["@np"];
            };
            "NixOS Options" = {
              urls = [{template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";}];
              updateInterval = 24 * 60 * 60 * 1000; # every day
              icon = "https://search.nixos.org/favicon-96x96.png";
              definedAliases = ["@no"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
              icon = "https://wiki.nixos.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@nw"];
            };
            "bing".metaData.hidden = true;
            "perplexity".metaData.hidden = true;
            "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias.
          };
        };
      };
    };
  };
}
