{
  pkgs,
  config,
  inputs,
  ...
}: {
  # Required to install flatpak
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
    extraPortals = with pkgs; [
      # xdg-desktop-portal-wlr
      kdePackages.xdg-desktop-portal-kde
      # xdg-desktop-portal-gtk
    ];
  };
  # Install flatpak binary.
  services.flatpak.enable = true;

  # So that regular binaries can be run.
  # This doesn't export to LD_LIBRARY_PATH in order to not affect packages that
  #  are correctly defined.
  # For packages that are not correctly defined you may have to
  #  "export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH" before running the command.
  #  For regular commands you can create an alias, but for programs you'll need
  #   to figure out something else, maybe use flatpak instead of a package?
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs;
    # https://nixos.wiki/wiki/Games
    # https://discourse.nixos.org/t/programs-nix-ld-libraries-expects-set-instead-of-list/56009/4
    # Should make most binaries run.
      pkgs.steam-run.args.multiPkgs pkgs
      ++ [
        # Add any missing dynamic libraries for unpackaged programs
        #  here, NOT in environment.systemPackages
      ];
  };

  environment.systemPackages = with pkgs; [
    gparted

    # Fonts.
    nerd-fonts.fira-code
    overpass # A nerd-fonts variant also exists.
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
  ];

  hm = {
    imports = [
      inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      # extensions = with pkgs.vscode-extensions;
      #   []
      #   ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace
      #   [];
    };

    home.packages = with pkgs; [
      # Archive tools.
      unrar
      p7zip
      # peazip

      # Document editors.
      kdePackages.kate
      libreoffice-qt6-fresh
      obsidian

      # Find LaTeX symbols by sketching them.
      hieroglyphic

      # Calculator.
      speedcrunch

      # Graphic editors.
      inkscape-with-extensions
      gimp-with-plugins
      freecad
      orca-slicer
      blender
      # Turn images into ASCII.
      letterpress

      # Downloading apps.
      qbittorrent

      # Media players.
      haruna
      mpv
      showtime

      # Video recording/streaming.
      obs-studio

      # Messaging.
      discord
      # App that aggregates websites and runs them in the background. Good for messaging websites.
      ferdium

      # App to play background noise like rain and wind.
      blanket

      # GUI for dealing with git repos integrated with GitHub.
      github-desktop

      # Browsers.
      ungoogled-chromium
      firefox
    ];

    # This will update flatpaks on rebuild, which will make rebuild not
    #  idempotent, oh well.
    services.flatpak.update.onActivation = true;
    services.flatpak.packages = [
      # App to play background music/noises from Animal Crossing.
      "camp.nook.nookdesktop"

      # Good looking widget that displays and controls the currently playing media.
      # Could be cool to use with something like a terminal music player.
      # But on KDE I could just use the included media player in the system tray.
      "dev.geopjr.Turntable"

      # App to draw things using characters to create ASCII art.
      "io.github.nokse22.asciidraw"

      # Cool internet radio app.
      "de.haeckerfelix.Shortwave"

      # Dictionary.
      "com.github.johnfactotum.QuickLookup"

      # Task manager like the one on windows. Looks nice.
      "io.missioncenter.MissionCenter"

      # App to make SVGs smaller.
      "re.sonny.OhMySVG"

      # App to see system logs.
      "org.gnome.Logs"

      # App to read files and add highlight lines based on tags.
      "io.github.phastmike.tags"

      # Tool to modify PDFs.
      "com.github.jeromerobert.pdfarranger"

      # App that adds website to the system menu.
      # TODO: See what this app does and figure out how to do it via nix. If I even want that.
      "io.github.zaedus.spider"

      # Downloading app.
      "io.github.giantpinkrobots.varia"

      # App with lots of utilities for developers, like a chmod calculator, diff, QR code generator, and regex tester.
      "me.iepure.devtoolbox"
      "io.gitlab.liferooter.TextPieces"

      # Music player with plugins.
      "io.github.quodlibet.QuodLibet"

      "org.raspberrypi.rpi-imager"
    ];

    home.file =
      config.lib.meta.mkAutostartScript "discord" ''discord --start-minimized''
      # // config.lib.meta.mkAutostartSymlink "discord" "${pkgs.discord}/share/applications/discord.desktop"
      ;
  };
}
