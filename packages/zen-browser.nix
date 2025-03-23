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
              widget-overflow-fixed-list = [];
              # Some extensions may appear in the nav-bar if they're not here.
              unified-extensions-area = [
                "dearrow_ajay_app-browser-action"
                "sponsorblocker_ajay_app-browser-action"
                "ublock0_raymondhill_net-browser-action"
                "gdpr_cavi_au_dk-browser-action"
                "_59c55aed-bdb3-4f2f-b81d-27011a689be6_-browser-action"
                "enhancerforyoutube_maximerf_addons_mozilla_org-browser-action"
                "plasma-browser-integration_kde_org-browser-action"
                "_036a55b4-5e72-4d05-a06c-cba2dfcc134a_-browser-action"
                "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action"
                "_a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad_-browser-action"
                "_d07ccf11-c0cd-4938-a265-2a4d6ad01189_-browser-action"
              ];
              nav-bar = [
                "back-button"
                "forward-button"
                "stop-reload-button"
                "customizableui-special-spring1"
                "urlbar-container"
                "customizableui-special-spring2"
                "save-to-pocket-button"
                "downloads-button"
                "unified-extensions-button"
                "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
                "addon_darkreader_org-browser-action"
                "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
                "sidebar-button"
              ];
              toolbar-menubar = [
                "menubar-items"
              ];
              TabsToolbar = [
                "tabbrowser-tabs"
                "new-tab-button"
                "firefox-view-button"
                "alltabs-button"
              ];
              vertical-tabs = [];
              PersonalToolbar = [];
            };
            seen = [];
            dirtyAreaCache = [];
            # This has to be bigger than the "currentVersion" in about:config or prefs.js.
            "currentVersion" = 21;
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
