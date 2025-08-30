{
  pkgs,
  config,
  umport,
  ...
}: {
  imports = umport {
    path = ./.;
    exclude = [./default-home.nix ./default-system.nix ./vm.nix];
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      # This breaks "nix develop".
      # cd ~/home/
    '';
  };

  # Tool to locate the nixpkgs package providing a certain file.
  programs.nix-index = {
    enable = true;
    # Makes the command-not-found error return the nixpkgs package that contains it.
    enableBashIntegration = true;
  };

  programs.zoxide.enable = true;

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = with pkgs; [
    # Nix formatter.
    alejandra
    # Nix language server.
    nil
    # Nix package version diff tool.
    nvd

    # Library for notifications, used in rebuild.sh.
    libnotify
    # find replacement, used in rebuild.sh together with update-nix-fetchgit.
    fd
    update-nix-fetchgit

    # Tool to see file changes in real time.
    fswatch

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
    # Tool to remove large files from git history. Call with "bfg".
    bfg-repo-cleaner
    # TUI for git.
    lazygit

    # App to give quick examples of how to use most commands.
    tldr

    # CLI tool to run programs without installing them on Nix. Functionally an easier to use nix-shell. Requires nix-index.
    comma

    ungoogled-chromium

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
    }) (builtins.attrNames files))
    // {
      # Some winapps configuration
      ".config/winapps/winapps.conf".text = ''
        ##################################
        #   WINAPPS CONFIGURATION FILE   #
        ##################################

        # INSTRUCTIONS
        # - Leading and trailing whitespace are ignored.
        # - Empty lines are ignored.
        # - Lines starting with '#' are ignored.
        # - All characters following a '#' are ignored.

        # [WINDOWS USERNAME]
        RDP_USER="Pebble"

        # [WINDOWS PASSWORD]
        # NOTES:
        # - If using FreeRDP v3.9.0 or greater, you *have* to set a password
        RDP_PASS="pebble"

        # [WINDOWS DOMAIN]
        # DEFAULT VALUE: "" (BLANK)
        RDP_DOMAIN=""

        # [WINDOWS IPV4 ADDRESS]
        # NOTES:
        # - If using 'libvirt', 'RDP_IP' will be determined by WinApps at runtime if left unspecified.
        # DEFAULT VALUE:
        # - 'docker': '127.0.0.1'
        # - 'podman': '127.0.0.1'
        # - 'libvirt': "" (BLANK)
        RDP_IP=""

        # [VM NAME]
        # NOTES:
        # - Only applicable when using 'libvirt'
        # - The libvirt VM name must match so that WinApps can determine VM IP, start the VM, etc.
        # DEFAULT VALUE: 'RDPWindows'
        VM_NAME="RDPWindows"

        # [WINAPPS BACKEND]
        # DEFAULT VALUE: 'docker'
        # VALID VALUES:
        # - 'docker'
        # - 'podman'
        # - 'libvirt'
        # - 'manual'
        WAFLAVOR="libvirt"

        # [DISPLAY SCALING FACTOR]
        # NOTES:
        # - If an unsupported value is specified, a warning will be displayed.
        # - If an unsupported value is specified, WinApps will use the closest supported value.
        # DEFAULT VALUE: '100'
        # VALID VALUES:
        # - '100'
        # - '140'
        # - '180'
        RDP_SCALE="100"

        # [MOUNTING REMOVABLE PATHS FOR FILES]
        # NOTES:
        # - By default, `udisks` (which you most likely have installed) uses /run/media for mounting removable devices.
        #   This improves compatibility with most desktop environments (DEs).
        # ATTENTION: The Filesystem Hierarchy Standard (FHS) recommends /media instead. Verify your system's configuration.
        # - To manually mount devices, you may optionally use /mnt.
        # REFERENCE: https://wiki.archlinux.org/title/Udisks#Mount_to_/media
        REMOVABLE_MEDIA="/run/media"

        # [ADDITIONAL FREERDP FLAGS & ARGUMENTS]
        # NOTES:
        # - You can try adding /network:lan to these flags in order to increase performance, however, some users have faced issues with this.
        # DEFAULT VALUE: '/cert:tofu /sound /microphone +home-drive'
        # VALID VALUES: See https://github.com/awakecoding/FreeRDP-Manuals/blob/master/User/FreeRDP-User-Manual.markdown
        RDP_FLAGS="/cert:tofu /sound /microphone +home-drive /multimon /kbd:unicode"

        # [DEBUG WINAPPS]
        # NOTES:
        # - Creates and appends to ~/.local/share/winapps/winapps.log when running WinApps.
        # DEFAULT VALUE: 'true'
        # VALID VALUES:
        # - 'true'
        # - 'false'
        DEBUG="true"

        # [AUTOMATICALLY PAUSE WINDOWS]
        # NOTES:
        # - This is currently INCOMPATIBLE with 'manual'.
        # DEFAULT VALUE: 'off'
        # VALID VALUES:
        # - 'on'
        # - 'off'
        AUTOPAUSE="off"

        # [AUTOMATICALLY PAUSE WINDOWS TIMEOUT]
        # NOTES:
        # - This setting determines the duration of inactivity to tolerate before Windows is automatically paused.
        # - This setting is ignored if 'AUTOPAUSE' is set to 'off'.
        # - The value must be specified in seconds (to the nearest 10 seconds e.g., '30', '40', '50', etc.).
        # - For RemoteApp RDP sessions, there is a mandatory 20-second delay, so the minimum value that can be specified here is '20'.
        # - Source: https://techcommunity.microsoft.com/t5/security-compliance-and-identity/terminal-services-remoteapp-8482-session-termination-logic/ba-p/246566
        # DEFAULT VALUE: '300'
        # VALID VALUES: >=20
        AUTOPAUSE_TIME="300"

        # [FREERDP COMMAND]
        # NOTES:
        # - WinApps will attempt to automatically detect the correct command to use for your system.
        # DEFAULT VALUE: "" (BLANK)
        # VALID VALUES: The command required to run FreeRDPv3 on your system (e.g., 'xfreerdp', 'xfreerdp3', etc.).
        FREERDP_COMMAND=""

        # [TIMEOUTS]
        # NOTES:
        # - These settings control various timeout durations within the WinApps setup.
        # - Increasing the timeouts is only necessary if the corresponding errors occur.
        # - Ensure you have followed all the Troubleshooting Tips in the error message first.

        # PORT CHECK
        # - The maximum time (in seconds) to wait when checking if the RDP port on Windows is open.
        # - Corresponding error: "NETWORK CONFIGURATION ERROR" (exit status 13).
        # DEFAULT VALUE: '5'
        PORT_TIMEOUT="5"

        # RDP CONNECTION TEST
        # - The maximum time (in seconds) to wait when testing the initial RDP connection to Windows.
        # - Corresponding error: "REMOTE DESKTOP PROTOCOL FAILURE" (exit status 14).
        # DEFAULT VALUE: '30'
        RDP_TIMEOUT="30"

        # APPLICATION SCAN
        # - The maximum time (in seconds) to wait for the script that scans for installed applications on Windows to complete.
        # - Corresponding error: "APPLICATION QUERY FAILURE" (exit status 15).
        # DEFAULT VALUE: '60'
        APP_SCAN_TIMEOUT="60"

        # WINDOWS BOOT
        # - The maximum time (in seconds) to wait for the Windows VM to boot if it is not running, before attempting to launch an application.
        # DEFAULT VALUE: '120'
        BOOT_TIMEOUT="120"
      '';
    };

  # Some virt-manager configuration
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  home.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";
}
