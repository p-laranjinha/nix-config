{pkgs, ...}: {
  services.syncthing = {
    enable = true;
    tray.enable = false;
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

  systemd.user.services.syncthingtray = {
    Unit = {
      Description = "Launch SyncthingTray on startup.";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = ''${pkgs.syncthingtray}'';
    };
  };
}
