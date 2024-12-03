{...}: {
  services.syncthing = {
    enable = true;
    #tray.enable = true;
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
}
