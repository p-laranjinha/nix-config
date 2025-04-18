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
      cd ~/home/
    '';
  };

  programs.zoxide.enable = true;

  # Allow fonts installed with home-packages.
  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = with pkgs; [
    alejandra # Nix formatter.
    nil # Nix language server.
    nvd # Nix package version diff tool.

    nerd-fonts.fira-code

    libnotify # Library for notifications, used in rebuild.sh.
    fd # find replacement, used in rebuild.sh together with update-nix-fetchgit.
    update-nix-fetchgit

    kdePackages.kate
    fswatch # Tool to see file changes in real time.

    unrar

    inkscape-with-extensions
    gimp-with-plugins
    freecad
    orca-slicer
    blender

    # rpi-imager # Tool to create SD cards with OSs for Raspberry Pis.

    obsidian
    quodlibet
    discord
    # speedcrunch
    qalculate-qt
    qbittorrent
    devtoolbox
    obs-studio

    blanket
    # fooyin

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
    "camp.nook.nookdesktop"
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
