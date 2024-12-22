{
  pkgs,
  flake-inputs,
  config,
  ...
}: {
  programs.bash.enable = true;

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

    freecad
    orca-slicer
    flake-inputs.cq-editor

    # rpi-imager # Tool to create SD cards with OSs for Raspberry Pis.

    obsidian
    quodlibet
    discord
    # speedcrunch
    qalculate-qt
    qbittorrent
    devtoolbox

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

  # Autostart
  home.file = builtins.listToAttrs (builtins.map (x: {
      name = ".config/autostart/${x}";
      value = {source = config.lib.file.mkOutOfStoreSymlink "${config.home.profileDirectory}/share/applications/${x}";};
    })
    [
      "discord.desktop"
    ]);
}
