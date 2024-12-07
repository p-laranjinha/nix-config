{pkgs, ...}: {
  imports = [
    ./build123d.nix
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "~/nixos/rebuild.sh";
    };
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      search = {
        force = true;
        #engines = {};
        order = [
          "DuckDuckGo"
          "Google"
        ];
      };
      settings = {};
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        ublock-origin
        darkreader
      ];
    };
  };

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = with pkgs; [
    alejandra # Nix formatter
    nil # Nix language server
    libnotify
    kdePackages.kate
    fswatch

    freecad
    orca-slicer

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
