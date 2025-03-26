# https://github.com/0xc000022070/zen-browser-flake/issues/9#issuecomment-2711057434
{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  applicationName = "Zen Browser";
  modulePath = [
    "programs"
    "zen-browser"
  ];
  mkFirefoxModule = import "${inputs.home-manager.outPath}/modules/programs/firefox/mkFirefoxModule.nix";
  zen-themes-repo = pkgs.fetchgit {
    url = "https://github.com/zen-browser/theme-store";
    rev = "2a9820d3e93530a97140e82c9b20f2edd6c431c9"; # HEAD
    sha256 = "0b9ic42b3sbir1k7rqyq6k1rbmqq4klva52543h9hwh0zvwbkqcw";
    # sparseCheckout causes update-nix-fetchgit to have wrong hash.
    # sparseCheckout = [ "/themes/81fcd6b3-f014-4796-988f-6c3cb3874db8" ];
  };
  zen-themes = [
    "81fcd6b3-f014-4796-988f-6c3cb3874db8" # Zen Context Menu
    "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
  ];
in {
  imports = [
    (mkFirefoxModule {
      inherit modulePath;
      name = applicationName;
      wrappedPackageName = "zen-browser-unwrapped";
      unwrappedPackageName = "zen-browser";
      visible = true;
      platforms = {
        linux = {
          vendorPath = ".zen";
          configPath = ".zen";
        };
        darwin = {
          configPath = "Library/Application Support/Zen";
        };
      };
    })
  ];

  options.my.home.features.zen-browser = {
    enable = lib.mkEnableOption "";
  };

  config = {
    # home.file =
    #   builtins.listToAttrs (builtins.map (theme: {
    #       name = "${config.home.homeDirectory}/.zen/default/chrome/zen-themes/${theme}";
    #       value = {
    #         source = "${zen-themes-repo}/themes/${theme}";
    #         recursive = true;
    #       };
    #     })
    #     zen-themes)
    #   // {
    #     "${config.home.homeDirectory}/.zen/default/zen-themes.json".text = "{${builtins.toString (
    #       builtins.map (theme: ''
    #         "${theme}":
    #           ${builtins.toJSON ((builtins.fromJSON (builtins.readFile "${zen-themes-repo}/themes/${theme}/theme.json")) // {enabled = true;})}${
    #           if theme == builtins.tail zen-themes
    #           then ""
    #           else ","
    #         }
    #       '')
    #       zen-themes
    #     )}}";
    #   }
    #   // {
    #     "${config.home.homeDirectory}/.zen/default/chrome/zen-themes.css".text = "${builtins.toString (builtins.map (theme: ''@import url("file///home/pebble/.zen/default/chrome/zen-themes/${theme}/chrome.css");'') zen-themes)}";
    #   };

    programs.zen-browser = {
      enable = true;
      package =
        pkgs.wrapFirefox
        (inputs.zen-browser.packages.${pkgs.system}.default.overrideAttrs (prevAttrs: {
          passthru =
            prevAttrs.passthru
            or {}
            // {
              inherit applicationName;
              binaryName = "zen";

              ffmpegSupport = true;
              gssSupport = true;
              gtk3 = pkgs.gtk3;
            };
        }))
        {
          icon = "zen-beta";
          wmClass = "zen";
          hasMozSystemDirPatch = false;
        };

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
          "browser.urlbar.maxRichResults" = 20;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.search.separatePrivateDefault" = false;
          "browser.newtabpage.pinned" = []; # Removes "Search with Google" from search results
          "zen.splitView.change-on-hover" = true;
          "zen.theme.accent-color" = "#aac7ff"; # The first blue option
          "zen.urlbar.replace-newtab" = true; # Set this to false to go back to regular new tab

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
                "tabbrowser-tabs"
              ];
              vertical-tabs = [];
              PersonalToolbar = [];
              zen-sidebar-top-buttons = [];
              zen-sidebar-bottom-buttons = [
                "preferences-button"
                "downloads-button"
                "zen-workspaces-button"
                "sidebar-button"
                "zen-expand-sidebar-button"
              ];
              # Some extensions may appear in the nav-bar if they're not here.
              # The extensions appear in this order.
              unified-extensions-area = [
                "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action" # Bitwarden
                "addon_darkreader_org-browser-action" # Dark Reader
                "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action" # Violentmonkey
                "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action" # Stylus
                "_d07ccf11-c0cd-4938-a265-2a4d6ad01189_-browser-action" # Web Archives
                "dearrow_ajay_app-browser-action"
                "sponsorblocker_ajay_app-browser-action"
                "ublock0_raymondhill_net-browser-action"
                "gdpr_cavi_au_dk-browser-action"
                "_59c55aed-bdb3-4f2f-b81d-27011a689be6_-browser-action"
                "enhancerforyoutube_maximerf_addons_mozilla_org-browser-action"
                "_036a55b4-5e72-4d05-a06c-cba2dfcc134a_-browser-action"
                "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action"
                "_a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad_-browser-action"
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
          default = "ddg";
          order = [
            "ddg"
            "google"
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
                      name = "channel";
                      value = "unstable";
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
              icon = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@nw"];
            };
            "bing".metaData.hidden = true;
            "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias.
          };
        };
      };
    };
  };
}
