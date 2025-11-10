{
  pkgs,
  config,
  ...
}: {
  hm = {
    services.syncthing = {
      # WARNING: If something is wrong, syncthing will just not have any
      #  devices or folders.
      # INFO: Versioning cleanup interval uses a different method which
      #  nixpkgs doesn't seem to support.
      enable = true;
      settings = {
        devices = {
          "phone".id = "R2RNYGN-BZPUWLZ-6OEOT77-ALGBSJP-MD2JPBY-AOY2T72-UX25SEB-H47LVAO";
          "tablet".id = "XR6AZSI-APGKKIB-LWMMCKW-6E63TBX-KFBSLVG-7JYURKQ-TZNGESZ-IVNNDQ5";
        };
        folders = {
          "default" = {
            id = "default";
            path = "~/home/sync/default";
            devices = [
              "phone"
              "tablet"
            ];
            versioning = {
              type = "staggered";
              params = {
                #cleanInterval = "604800"; # clean once per week
                maxAge = "0"; # 1 year
              };
            };
          };
          "obsidian-vaults" = {
            id = "obsidian-vaults";
            path = "~/home/obsidian-vaults";
            devices = [
              "phone"
              "tablet"
            ];
            versioning = {
              type = "staggered";
              #cleanupIntervalS = "604800"; # clean once per week
              params.maxAge = "0"; # forever
            };
          };
          "music" = {
            id = "music";
            path = "~/home/audio/music";
            devices = [
              "phone"
            ];
            versioning = {
              type = "staggered";
              #cleanupIntervalS = "604800"; # clean once per week
              params.maxAge = "31536000"; # 1 year
            };
          };
          "tachiyomi-backup" = {
            id = "tachiyomi-backup";
            path = "~/home/sync/tachiyomi-backup";
            devices = [
              "phone"
              "tablet"
            ];
          };
          "WIT" = {
            id = "wit";
            path = "~/home/sync/WIT";
            devices = [
              "phone"
            ];
          };
        };
      };
    };

    systemd.user.services.syncthing.environment.STNODEFAULTFOLDER = "true";
    home.packages = with pkgs; [
      syncthingtray
    ];
    home.file = config.lib.meta.mkAutostartScript "syncthingtray" ''
      ${pkgs.syncthingtray}/bin/syncthingtray --wait
    '';
  };
}
