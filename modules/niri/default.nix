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
    fonts.packages = with pkgs; [
      # Used by flatpaks.
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
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
        configHome = vars.homeDirectory;
      };
      # Backend of udiskie to manager removable media.
      udisks2.enable = true;
    };
    # Sync greeter with DMS.
    users.users.${vars.username} = {
      extraGroups = [
        "greeter"
      ];
    };
    systemd.tmpfiles.rules = [
      "L+ /var/cache/dms-greeter/settings.json - - - - ${vars.homeDirectory}/.config/DankMaterialShell/settings.json"
      "Z /var/cache/dms-greeter/settings.json 777 ${vars.username} greeter - -"
      "L+ /var/cache/dms-greeter/session.json - - - - ${vars.homeDirectory}/.local/state/DankMaterialShell/session.json"
      "Z /var/cache/dms-greeter/session.json 777 ${vars.username} greeter - -"
      "L+ /var/cache/dms-greeter/colors.json - - - - ${vars.homeDirectory}/.cache/DankMaterialShell/dms-colors.json"
      "Z /var/cache/dms-greeter/colors.json 777 ${vars.username} greeter - -"

      "r ${vars.homeDirectory}/.config/gtk-3.0/settings.ini.backup - - - - -"
      "r ${vars.homeDirectory}/.config/gtk-4.0/gtk.css.backup - - - - -"
      "r ${vars.homeDirectory}/.config/gtk-4.0/settings.ini.backup - - - - -"
      "r ${vars.homeDirectory}/.gtkrc-2.0.backup - - - - -"
    ];
    hm = {
      home = {
        pointerCursor = {
          enable = true;
          name = "phinger-cursors-dark";
          package = pkgs.phinger-cursors;
          # Size doesn't seem to work with niri, set it in the config file.
          # size = 32;
        };
      };
      xdg.configFile = {
        "niri" = {
          source = funcs.mkMutableConfigSymlink ./config;
          force = true;
        };
        "mimeapps.list" = {
          source = funcs.mkMutableConfigSymlink ./mimeapps.list;
          force = true;
        };
        "DankMaterialShell/settings.json" = {
          source = funcs.mkMutableConfigSymlink ./dms-settings.json;
          force = true;
        };
        "menus/applications.menu" = {
          text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
          force = true;
        };
      };
      # https://danklinux.com/docs/dankmaterialshell/application-themes#gtk-applications
      # Run 'nwg-look' to check the available GTK themes.
      services.udiskie = {
        enable = true;
        settings = {
          program_options = {
            file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
            automount = "false";
          };
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
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          # Fonts used by flakpak (and other things).
          document-font-name = "Noto Sans 10";
          font-name = "Noto Sans 10";
          monospace-font-name = "FiraCode Nerd Font";
        };
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
    # TODO: bar layout and plugins
    # TODO: remove backup file
    # TODO: dim right screen
    # TODO: see if I can right click app widget for settings like fullscreen?
    # TODO: setup calendar
    # TODO: setup foot transparency
  };
}
