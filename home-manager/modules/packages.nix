{pkgs, ...}: {
  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "bash ~/nixos/rebuild";
    };
  };

  programs.firefox.enable = true;

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = with pkgs; [
    alejandra # Nix formatter
    kdePackages.kate

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
