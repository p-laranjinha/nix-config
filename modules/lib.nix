# For functions that depend on modules like nixos and home-manager, and options
#  and variables to be reused in multiple places.
# The functions and variables set here cannot be used inside the imports option.
# For more "pure" functions check ../lib
{
  this,
  config,
  lib,
  pkgs,
  funcs,
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
            value.source = funcs.mkOutOfStoreSymlink path;
          })
          config.opts.autostartSymlinks)
      );

    # https://mynixos.com/nixpkgs/option/_module.args
    # Additional arguments passed to each module.
    # The default arguments like 'lib' and 'config' cannot be modified.
    _module.args = {
      funcs = {
        mkOutOfStoreSymlink = path: config.hm.lib.file.mkOutOfStoreSymlink path;

        relativeToAbsoluteConfigPath = path: (this.configDirectory + removePrefix (toString ./..) (toString path));

        # Creates symlinks to these config files that can be changed without rebuilding.
        mkMutableConfigSymlink = path:
          funcs.mkOutOfStoreSymlink (funcs.relativeToAbsoluteConfigPath path);
      };
    };
  };
}
