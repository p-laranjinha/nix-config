{
  lib,
  config,
  pkgs,
  funcs,
  ...
}:
{
  config = lib.mkIf config.opts.niri {
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      kdePackages.dolphin
      nomacs # Image viewer
    ];
    programs = {
      niri.enable = true;
      dms-shell.enable = true;
      dsearch.enable = true;
    };
    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
    };
    hm.home.file.".config/niri".source = funcs.mkMutableConfigSymlink ./config;
    hm.home.pointerCursor = {
      enable = true;
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      # Size doesn't seem to work with niri, set it in the config file.
      # size = 32;
    };

    # TODO: keymaps
    # TODO: background apps
    # TODO: wallpapers (sync with greeter)
    # TODO: dms json in this repo
    # TODO: bar layout and plugins
    # TODO: remove backup file
    # TODO: dim right screen
    # TODO: see if I can right click app widget for settings like fullscreen?
    # TODO: fix fonts in apps like Mission Center
    # TODO: setup calendar
    # TODO: setup defaults like image viewer (File picker not working on https://wiki.nixos.org/wiki/Niri)
  };
}
