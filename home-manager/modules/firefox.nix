{pkgs, ...}: let
  # https://github.com/black7375/Firefox-UI-Fix
  lepton = pkgs.fetchzip {
    url = "https://github.com/black7375/Firefox-UI-Fix/releases/download/v8.6.5/Lepton.zip";
    sha256 = "sha256-W9Z6L/dVXR9nHbORl37SQWQV43rIKoXJTL7M/Gv2Xr0=";
    stripRoot = false; # Required for zip files with multiple root files.
  };
in {
  programs.firefox = {
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
        "browser.tabs.closeWindowWithLastTab" = false;
        "privacy.donottrackheader.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "browser.urlbar.maxRichResults" = 20;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            widget-overflow-fixed-list = [
            ];
            unified-extensions-area = [
              "ublock0_raymondhill_net-browser-action"
              "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
              "plasma-browser-integration_kde_org-browser-action"
            ];
            nav-bar = [
              "forward-button"
              "stop-reload-button"
              "back-button"
              "customizableui-special-spring1"
              "urlbar-container"
              "customizableui-special-spring2"
              "save-to-pocket-button"
              "downloads-button"
              "fxa-toolbar-menu-button"
              "unified-extensions-button"
              "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
              "addon_darkreader_org-browser-action"
            ];
            toolbar-menubar = [
              "menubar-items"
            ];
            TabsToolbar = [
              "firefox-view-button"
              "tabbrowser-tabs"
              "new-tab-button"
              "alltabs-button"
            ];
            vertical-tabs = [
            ];
            PersonalToolbar = [
              "import-button"
              "personal-bookmarks"
            ];
          };
          seen = [];
          dirtyAreaCache = [
            "nav-bar"
            "vertical-tabs"
            "PersonalToolbar"
            "unified-extensions-area"
            "toolbar-menubar"
            "TabsToolbar"
          ];
          # This has to be bigger than the "currentVersion" in about:config or prefs.js.
          "currentVersion" = 21;
          "newElementCount" = 0;
        };
      };
      extraConfig = builtins.readFile "${lepton}/user.js";
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        ublock-origin
        darkreader
        # The rest can just be installed by logging in to the Firefox account.
      ];
      search = {
        force = true;
        default = "DuckDuckGo";
        order = [
          "DuckDuckGo"
          "Google"
        ];
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
          "NixOS Wiki" = {
            urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@nw"];
          };
          "Bing".metaData.hidden = true;
          "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias.
        };
      };
    };
  };
}
