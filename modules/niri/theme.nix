# Theme (and fonts)
{
  lib,
  config,
  pkgs,
  vars,
  ...
}:
{
  config = lib.mkIf config.opts.niri {
    fonts.packages = with pkgs; [
      # Used by flatpaks.
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
    systemd.tmpfiles.rules = [
      # Remove these backups that break things when I switch from plasma to niri.
      "r ${vars.homeDirectory}/.config/gtk-3.0/settings.ini.backup - - - - -"
      "r ${vars.homeDirectory}/.config/gtk-4.0/gtk.css.backup - - - - -"
      "r ${vars.homeDirectory}/.config/gtk-4.0/settings.ini.backup - - - - -"
      "r ${vars.homeDirectory}/.gtkrc-2.0.backup - - - - -"
    ];
    environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      DMS_DISABLE_MATUGEN = "true"; # Disable theme generation
      # https://danklinux.com/docs/dankmaterialshell/application-themes#qt-applications
      QT_QPA_PLATFORMTHEME = "kde";
      QT_QPA_PLATFORMTHEME_QT6 = "kde";
    };
    hm = {
      home.pointerCursor = {
        enable = true;
        name = "phinger-cursors-dark";
        package = pkgs.phinger-cursors;
        # Size doesn't seem to work with niri, set it in the config file.
        # size = 32;
      };
      # https://danklinux.com/docs/dankmaterialshell/application-themes#gtk-applications
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
      # Use 'dconf-editor' to find options you can change with this.
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          # Fonts used by flakpak (and other things).
          document-font-name = "Noto Sans 10";
          font-name = "Noto Sans 10";
          monospace-font-name = "FiraCode Nerd Font";
        };
      };
    };
  };
}
