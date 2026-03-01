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
  imports = [
    ./calendar.nix
    ./greeter.nix
    ./theme.nix # includes fonts
    ./plugins.nix
  ];

  config = lib.mkIf config.opts.niri {
    environment.systemPackages = with pkgs; [
      inputs.dms.packages.${vars.hostPlatform}.default
      xwayland-satellite
      kdePackages.dolphin
      nomacs # Image viewer
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
      # Backend of udiskie which manages removable media.
      udisks2.enable = true;
    };
    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri";
    };
    hm = {
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
      # Service to manage removable media.
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
    };
  };
  # TODO: keymaps
  # TODO: remove backup file
  # TODO: dim right screen
  # TODO: figure out why the clipboard widget isn't showing history
}
