{
  lib,
  config,
  pkgs,
  inputs,
  vars,
  funcs,
  ...
}:
{
  config = lib.mkIf config.opts.niri {
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      kdePackages.dolphin
      nomacs # Image viewer
      inputs.dms.packages.${vars.hostPlatform}.default
    ];
    programs = {
      niri.enable = true;
      dms-shell = {
        enable = true;
        # Use latest dms and quickshell.
        package = inputs.dms.packages.${vars.hostPlatform}.default;
        quickshell.package = inputs.quickshell.packages.${vars.hostPlatform}.quickshell;
      };
      dsearch.enable = true;
    };
    services = {
      displayManager.dms-greeter = {
        enable = true;
        compositor.name = "niri";
      };
      # Backend of udiskie to manager removable media.
      udisks2.enable = true;
    };
    hm = {
      home = {
        file = {
          ".config/niri".source = funcs.mkMutableConfigSymlink ./config;
          ".config/mimeapps.list".source = funcs.mkMutableConfigSymlink ./mimeapps.list;
        };
        pointerCursor = {
          enable = true;
          name = "phinger-cursors-dark";
          package = pkgs.phinger-cursors;
          # Size doesn't seem to work with niri, set it in the config file.
          # size = 32;
        };
      };
      xdg.configFile."menus/applications.menu".text =
        builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
      # https://danklinux.com/docs/dankmaterialshell/application-themes#gtk-applications
      # Run 'nwg-look' to check the available GTK themes.
      services.udiskie = {
        enable = true;
        settings = {
          program_options = {
            file_manager = "${lib.getExe pkgs.kdePackages.dolphin}";
          };
          automount = false;
        };
      };
      gtk = {
        enable = true;
        colorScheme = "dark";
        theme = {
          name = "Breeze-Dark";
          package = pkgs.kdePackages.breeze-gtk;
        };
        iconTheme = {
          name = "breeze-dark";
          package = pkgs.kdePackages.breeze-icons;
        };
      };
      # https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523
      # https://danklinux.com/docs/dankmaterialshell/application-themes#qt-applications
      qt = {
        enable = true;
        style = {
          name = "breeze-dark";
        };
        platformTheme.name = "kde";
      };
    };
    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri";
      QT_QPA_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      DMS_DISABLE_MATUGEN = "true"; # Disable theme generation
      # https://danklinux.com/docs/dankmaterialshell/application-themes#qt-applications
      QT_QPA_PLATFORMTHEME = "kde";
      QT_QPA_PLATFORMTHEME_QT6 = "kde";
    };

    # TODO: keymaps
    # TODO: background apps
    # TODO: dms json in this repo
    # TODO: bar layout and plugins
    # TODO: remove backup file
    # TODO: dim right screen
    # TODO: see if I can right click app widget for settings like fullscreen?
    # TODO: setup calendar
    # TODO: sync greeter
  };
}
