{pkgs, ...}: {
  services.syncthing = {
    # WARNING: If something is wrong, syncthing will just not have any
    #  devices or folders.
    # INFO: Versioning cleanup interval uses a different method which
    #  nixpkgs doesn't seem to support.
    enable = true;
    settings = {
      devices = {
        "phone".id = "JU2TRHN-NJQPZUH-QPBTFZB-IEEDJKW-45V5IRV-6YSUSUS-OVWWEK3-Y4QPBAS";
        "tablet".id = "XR6AZSI-APGKKIB-LWMMCKW-6E63TBX-KFBSLVG-7JYURKQ-TZNGESZ-IVNNDQ5";
      };
      folders = {
        "Default" = {
          id = "default";
          path = "~/home/Sync/Default";
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
        "Obsidian Vaults" = {
          id = "obsidian-vaults";
          path = "~/home/Obsidian Vaults";
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
        "Music" = {
          id = "music";
          path = "~/home/Audio/Music";
          devices = [
            "phone"
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
            "tablet"
          ];
        };
        "WIT" = {
          id = "wit";
          path = "~/home/Sync/WIT";
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
}
