{
  lib,
  config,
  ...
}: let
  cfg = config.personal.remote-access;
in {
  options.personal.remote-access = {
    sunshine = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "If Sunshine is used for remote access instead of xrdp.";
    };
  };

  config = {
    networking.interfaces.enp14s0.wakeOnLan.enable = true;

    services.tailscale.enable = true;

    services.xrdp.enable = ! cfg.sunshine;
    services.xrdp.defaultWindowManager = "startplasma-x11";
    services.xrdp.openFirewall = ! cfg.sunshine;

    services.openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = ["pebble"]; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };
    services.fail2ban.enable = true;

    services.sunshine = {
      enable = cfg.sunshine;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      settings = {
        output_name = 0;
      };
    };
    services.displayManager.autoLogin = {
      # There is an autostart script somewhere else that locks on autologin.
      enable = cfg.sunshine;
      user = "pebble";
    };
  };
}
