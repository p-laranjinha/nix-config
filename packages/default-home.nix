{
  pkgs,
  config,
  umport,
  ...
}: {
  imports = umport {
    path = ./.;
    exclude = [./default-home.nix ./default-system.nix];
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      # This breaks "nix develop".
      # cd ~/home/
    '';
  };

  programs.zoxide.enable = true;

  # Allow fonts installed with home-packages.
  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = with pkgs; [
    # Nix formatter.
    alejandra
    # Nix language server.
    nil
    # Nix package version diff tool.
    nvd

    # App with lots of utilities for developers, like a chmod calculator, diff, QR code generator, and regex tester.
    # devtoolbox
    textpieces

    # Font.
    nerd-fonts.fira-code

    # Library for notifications, used in rebuild.sh.
    libnotify
    # find replacement, used in rebuild.sh together with update-nix-fetchgit.
    fd
    update-nix-fetchgit

    # Tool to see file changes in real time.
    fswatch

    # Archive tools.
    unrar
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

    # Music player with plugins.
    # quodlibet

    # GUI for dealing with git repos integrated with GitHub.
    github-desktop
    # Tool to remove large files from git history. Call with "bfg".
    bfg-repo-cleaner
    # TUI for git.
    lazygit

    # App to give quick examples of how to use most commands.
    tldr

    # Game.
    mindustry

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    streamcontroller
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

    # Neat game.
    "app.drey.MultiplicationPuzzle"

    # App that adds website to the system menu.
    # TODO: See what this app does and figure out how to do it via nix. If I even want that.
    "io.github.zaedus.spider"

    # Downloading app.
    "io.github.giantpinkrobots.varia"

    "org.raspberrypi.rpi-imager"
  ];

  # Autostarts.
  home.file = let
    scripts = builtins.mapAttrs (name: script:
      pkgs.writeText "${name}.desktop" ''
        [Desktop Entry]
        Exec=${pkgs.writeShellScript name script}
        Name=${name}
        Type=Application
        X-KDE-AutostartScript=true
      '');
    outOfStore = builtins.mapAttrs (
      name: source:
        config.lib.file.mkOutOfStoreSymlink source
    );
  in let
    files =
      scripts {
        "discord-minimized" = ''
          discord --start-minimized
        '';
        "syncthingtray" = ''
          ${pkgs.syncthingtray}/bin/syncthingtray --wait
        '';
        # Used so that I can access this PC remotely using Sunshine but still have a password.
        "lock-if-autologin" = ''
          #! /usr/bin/env nix-shell
          #! nix-shell -i bash -p procps
          SDDM_TEST=`pgrep -xa sddm-helper`
          [[ $SDDM_TEST == *"--autologin"* ]] && loginctl lock-session
        '';
      }
      // outOfStore {
        "betterbird" = "${config.home.homeDirectory}/.local/share/flatpak/exports/share/applications/eu.betterbird.Betterbird.desktop";
      }
      // {
        # inStore
        # "discord" = "${pkgs.discord}/share/applications/discord.desktop
      };
  in
    builtins.listToAttrs (builtins.map (name: {
      name = ".config/autostart/${name}.desktop";
      value = {source = files.${name};};
    }) (builtins.attrNames files));
}
