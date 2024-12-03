{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    # Environment variables.
    ./modules/environment.nix

    # Dotfiles.
    ./modules/files.nix

    ./modules/packages.nix

    ./modules/plasma.nix

    ./modules/git.nix

    ./modules/syncthing.nix
  ];

  home = {
    username = "pebble";
    homeDirectory = "/home/pebble";
  };

  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
