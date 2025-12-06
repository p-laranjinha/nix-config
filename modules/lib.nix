# For lib functions that depend on modules like nixos and home-manager.
# There might be a way to create these functions with mkOption instead of
#  abusing config.lib.meta, but I don't think it's worth the trouble.
# These functions are accessed by config.lib.meta.XXX
# For more "pure" functions check ../lib
{
  this,
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  # Check the NixOS GitHub manual for info on option types.
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/doc/manual/development/option-types.section.md
  options.opts = {
    autostartScripts = mkOption {
      default = {};
      type = with types; attrsOf str;
    };
    autostartSymlinks = mkOption {
      default = {};
      type = with types; attrsOf path;
    };
  };

  config = {
    hm.home.file =
      (listToAttrs (mapAttrsToList (name: script: {
          name = ".config/autostart/${name}.script.desktop";
          value.text = ''
            [Desktop Entry]
            Exec=${pkgs.writeShellScript name script}
            Name=${name}
            Type=Application
            X-KDE-AutostartScript=true
          '';
        })
        config.opts.autostartScripts))
      // (
        listToAttrs (mapAttrsToList (name: path: {
            name = ".config/autostart/${name}.symlink.desktop";
            value.source = config.lib.meta.mkOutOfStoreSymlink path;
          })
          config.opts.autostartSymlinks)
      );

    lib.meta = {
      mkOutOfStoreSymlink = path: config.hm.lib.file.mkOutOfStoreSymlink path;

      relativeToAbsoluteConfigPath = path: (this.configDirectory + removePrefix (toString ./..) (toString path));

      # Creates symlinks to these config files that can be changed without rebuilding.
      mkMutableConfigSymlink = path:
        config.lib.meta.mkOutOfStoreSymlink (config.lib.meta.relativeToAbsoluteConfigPath path);
    };
  };
}
