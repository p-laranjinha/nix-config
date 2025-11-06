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
          "phone-old".id = "JU2TRHN-NJQPZUH-QPBTFZB-IEEDJKW-45V5IRV-6YSUSUS-OVWWEK3-Y4QPBAS";
          "tablet".id = "XR6AZSI-APGKKIB-LWMMCKW-6E63TBX-KFBSLVG-7JYURKQ-TZNGESZ-IVNNDQ5";
        };
        folders = {
          "Default" = {
            id = "default";
            path = "~/home/Sync/Default";
            devices = [
              "phone"
              "phone-old"
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
          "Obsidian Vaults" = {
            id = "obsidian-vaults";
            path = "~/home/Obsidian Vaults";
            devices = [
              "phone"
              "phone-old"
              "tablet"
            ];
            versioning = {
              type = "staggered";
              #cleanupIntervalS = "604800"; # clean once per week
              params.maxAge = "0"; # forever
            };
          };
          "Music" = {
            id = "music";
            path = "~/home/audio/Music";
            devices = [
              "phone"
              "phone-old"
            ];
            versioning = {
              type = "staggered";
              #cleanupIntervalS = "604800"; # clean once per week
              params.maxAge = "31536000"; # 1 year
            };
          };
          "Tachiyomi Backup" = {
            id = "tachiyomi-backup";
            path = "~/home/Sync/Tachiyomi Backup";
            devices = [
              "phone"
              "phone-old"
              "tablet"
            ];
          };
          "WIT" = {
            id = "wit";
            path = "~/home/Sync/WIT";
            devices = [
              "phone"
              "phone-old"
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
