# https://github.com/pinpox/nixos/blob/e6d561a2f91219fa83d895fb0997a67d8f621604/home-manager/modules/calendar/default.nix
{
  lib,
  config,
  funcs,
  ...
}:
{
  config = lib.mkIf config.opts.niri {
    hm = {
      programs.khal = {
        enable = true;
        locale = {
          timeformat = "%H:%M";
          dateformat = "%Y-%m-%d";
          longdateformat = "%Y-%m-%d";
          datetimeformat = "%Y-%m-%d %H:%M";
          longdatetimeformat = "%Y-%m-%d %H:%M";
          firstweekday = 6;
          unicode_symbols = true;
        };
      };
      programs.vdirsyncer = {
        enable = true;
        statusPath = "~/.calendars/status";
      };
      services.vdirsyncer.enable = true;
      # 'vdirsyncer discover calendar_personal' has to be run to log into my account.
      accounts.calendar.accounts."personal" = {
        primary = true;
        primaryCollection = "plcasimiro2000@gmail.com";
        remote = {
          type = "google_calendar";
        };
        local = {
          type = "filesystem";
          path = "~/.calendars/Personal";
        };
        khal = {
          enable = true;
          type = "discover";
        };
        vdirsyncer = {
          enable = true;
          collections = [
            "from a"
            "from b"
          ];
          conflictResolution = "remote wins";
          metadata = [
            "color"
            "displayname"
          ];
          tokenFile = "~/.vdirsyncer/google_calendar_token";
          clientIdCommand = [
            "sops"
            "-d"
            (funcs.relativeToAbsoluteConfigPath ./google-calendar-client-id)
          ];
          clientSecretCommand = [
            "sops"
            "-d"
            (funcs.relativeToAbsoluteConfigPath ./google-calendar-client-secret)
          ];
        };
      };
    };
  };
}
