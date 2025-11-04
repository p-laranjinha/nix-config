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
  home.file = let
    folders = {
      "Desktop" = "Desktop";
      "Downloads" = "Downloads";
      "Audio" = "Music";
      "Images" = "Pictures";
      "Videos" = "Videos";
      "Documents" = "Documents";
      ".config" = ".config";
      ".local" = ".local";
      ".zen" = ".zen";
    };
  in
    builtins.listToAttrs (builtins.map (target: {
      name = "home/${target}";
      value = {source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/${folders.${target}}";};
    }) (builtins.attrNames folders))
    // {
      # Allows for unfree packages to be used by nix-shell
      ".config/nixpkgs/config.nix".text = ''{ allowUnfree = true; }'';
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
  home.stateVersion = "25.05"; # Please read the comment before changing.
}
