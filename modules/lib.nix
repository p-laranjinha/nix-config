# For lib functions that depend on modules like nixos and home-manager.
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
  lib.meta = {
    mkOutOfStoreSymlink = path: config.hm.lib.file.mkOutOfStoreSymlink path;

    # Creates symlinks to these config files that can be changed without rebuilding.
    mkMutableConfigSymlink = path:
      config.lib.meta.mkOutOfStoreSymlink
      (this.configDirectory + removePrefix (toString ./..) (toString path));

    # Use like: hm.home.file = mkAutostart(Script/Symlink) "name" ''script''
    # Use // to extend hm if needed.
    mkAutostartScript = name: script: {
      ".config/autostart/${name}.desktop".text = ''
        [Desktop Entry]
        Exec=${pkgs.writeShellScript name script}
        Name=${name}
        Type=Application
        X-KDE-AutostartScript=true
      '';
    };
    mkAutostartSymlink = name: path: {
      ".config/autostart/${name}.desktop".source = config.lib.meta.mkOutOfStoreSymlink path;
    };
  };
}
