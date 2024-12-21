{lib, ...}: let
  # This commented line gets the profile automatically but is inpure.
  #profile = lib.lists.findFirst (value: (lib.strings.hasSuffix "default-default" value)) "" (lib.mapAttrsToList (name: value: name) (builtins.readDir /home/pebble/.var/app/eu.betterbird.Betterbird/.thunderbird));\
  profile = "egxcshns.default-default";
  userjs = lib.strings.concatStrings [".var/app/eu.betterbird.Betterbird/.thunderbird/" profile "/user.js"];
in {
  services.flatpak.packages = [
    "eu.betterbird.Betterbird"
  ];

  services.flatpak.overrides = {
    "eu.betterbird.Betterbird".Context.filesystems = [
      "host"
    ];
  };

  home.file."${userjs}".text = ''
    user_pref("mail.startupMinimized", true);
    user_pref("mail.minimizeToTray", true);
  '';
}
