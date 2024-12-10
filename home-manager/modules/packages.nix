{
  pkgs,
  inputs,
  ...
}: {
  programs.bash.enable = true;

  programs.zoxide.enable = true;

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
      #preferences = {
      #  "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
      #  "extensions.pocket.enabled" = false;
      #  "extensions.screenshots.disabled" = true;
      #  "browser.topsites.contile.enabled" = false;
      #  "browser.formfill.enable" = false;
      #  "browser.search.suggest.enabled" = false;
      #  "browser.search.suggest.enabled.private" = false;
      #  "browser.urlbar.suggest.searches" = false;
      #  "browser.urlbar.showSearchSuggestionsFirst" = false;
      #};
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
      settings = {};
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        ublock-origin
        darkreader
        # The rest can just be installed by logging in to the Firefox account.
      ];
    };
  };

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = with pkgs; [
    alejandra # Nix formatter
    nil # Nix language server
    libnotify # Library for notifications, used in rebuild.sh
    kdePackages.kate
    fswatch # Tool to see file changes in real time

    freecad
    orca-slicer

    inputs.cq-editor

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
