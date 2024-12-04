{pkgs, ...}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "pebble";
    dataDir = "/home/pebble";
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
        };
        "Obsidian Vaults" = {
          id = "obsidian-vaults";
          path = "~/Obsidian Vaults";
          devices = [
            "phone"
            "tablet"
          ];
        };
        "Music" = {
          id = "music";
          path = "~/Music/Music";
          devices = [
            "phone"
          ];
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
            "tablet"
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
    enable = false;
    description = "Launch SyncthingTray on startup.";
    script = ''${pkgs.syncthingtray}/bin/syncthingtray --wait'';
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
  };
}
