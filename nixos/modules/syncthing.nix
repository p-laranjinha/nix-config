{pkgs, ...}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "pebble";
    dataDir = "/home/pebble";
    settings = {
      devices = {
        phone.id = "JU2TRHN-NJQPZUH-QPBTFZB-IEEDJKW-45V5IRB-6YSUSUS-OVWWEK3-Y4QPBAS";
      };
      folders = {
        "Tachiyomi Backup" = {
          id = "tachiyomi-backup";
          path = "~/Sync/Tachiyomi Backup";
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
    enable = false;
    description = "Launch SyncthingTray on startup.";
    script = ''${pkgs.syncthingtray}/bin/syncthingtray --wait'';
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
  };
}
