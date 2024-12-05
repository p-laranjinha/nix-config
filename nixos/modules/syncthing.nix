{pkgs, ...}: {
  services.syncthing = {
    # WARNING: If something is wrong, syncthing will just not have any
    #  devices or folders.
    # INFO: Versioning cleanup interval uses a different method which
    #  nixpkgs doesn't seem to support.
    enable = true;
    openDefaultPorts = true;
    user = "pebble";
    dataDir = "/home/pebble";
    overrideDevices = false;
    overrideFolders = false;
    settings = {
      devices = {
        "phone".id = "JU2TRHN-NJQPZUH-QPBTFZB-IEEDJKW-45V5IRV-6YSUSUS-OVWWEK3-Y4QPBAS";
        "tablet".id = "XR6AZSI-APGKKIB-LWMMCKW-6E63TBX-KFBSLVG-7JYURKQ-TZNGESZ-IVNNDQ5";
      };
      folders = {
        "Default" = {
          id = "default";
          path = "~/Sync/Default";
          devices = [
            "phone"
            "tablet"
          ];
          versioning = {
            type = "staggered";
            #cleanupIntervalS = "604800"; # clean once per week
            params.maxAge = "31536000"; # 1 year
          };
        };
        "Obsidian Vaults" = {
          id = "obsidian-vaults";
          path = "~/Obsidian Vaults";
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
          path = "~/Music/Music";
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
          path = "~/Sync/Tachiyomi Backup";
          devices = [
            "phone"
            "tablet"
          ];
        };
        "WIT" = {
          id = "wit";
          path = "~/Sync/WIT";
          devices = [
            "phone"
          ];
        };
      };
    };
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  environment.systemPackages = with pkgs; [
    syncthingtray
  ];
  systemd.user.services.syncthingtray = {
    description = "Launch SyncthingTray on startup.";
    #preStart = ''sleep 5'';
    script = ''${pkgs.syncthingtray}/bin/syncthingtray --wait'';
    wantedBy = ["graphical-session.target"];
    after = ["syncthing.service"];
  };
}
