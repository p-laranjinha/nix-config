{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./firefox.nix
  ];

  programs.bash.enable = true;

  programs.zoxide.enable = true;

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

    obsidian

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
