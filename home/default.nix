{
  config,
  umport,
  ...
}: {
  imports =
    umport {
      path = ./.;
      exclude = [./default.nix];
    }
    ++ [../packages/default-home.nix];
  home = {
    username = "pebble";
    homeDirectory = "/home/pebble";
  };

  # Symlinking important folders to a sub home folder to have a cleaner home
  home.file."home/Desktop".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Desktop";
  home.file."home/Downloads".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Downloads";
  home.file."home/Audio".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Music";
  home.file."home/Images".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Pictures";
  home.file."home/Videos".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Videos";
  home.file."home/Documents".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents";

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
