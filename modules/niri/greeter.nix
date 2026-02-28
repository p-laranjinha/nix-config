{
  lib,
  config,
  vars,
  funcs,
  ...
}:
{
  config = lib.mkIf config.opts.niri {
    services = {
      displayManager.dms-greeter = {
        enable = true;
        compositor.name = "niri";
        configHome = vars.homeDirectory;
      };
    };

    # Sync greeter with DMS.
    users.users.${vars.username} = {
      extraGroups = [
        "greeter"
      ];
    };
    systemd.tmpfiles.rules = [
      "L+ /var/cache/dms-greeter/settings.json - - - - ${funcs.relativeToAbsoluteConfigPath ./dms-settings.json}"
      "Z /var/cache/dms-greeter/settings.json 777 ${vars.username} greeter - -"
      "Z ${funcs.relativeToAbsoluteConfigPath ./dms-settings.json} 777 ${vars.username} greeter - -"

      "L+ /var/cache/dms-greeter/session.json - - - - ${vars.homeDirectory}/.local/state/DankMaterialShell/session.json"
      "Z /var/cache/dms-greeter/session.json 777 ${vars.username} greeter - -"
      "Z ${vars.homeDirectory}/.local/state/DankMaterialShell/session.json 777 ${vars.username} greeter - -"

      "L+ /var/cache/dms-greeter/colors.json - - - - ${vars.homeDirectory}/.cache/DankMaterialShell/dms-colors.json"
      "Z /var/cache/dms-greeter/colors.json 777 ${vars.username} greeter - -"
      "Z ${vars.homeDirectory}/.cache/DankMaterialShell/dms-colors.json 777 ${vars.username} greeter - -"
    ];
  };
}
