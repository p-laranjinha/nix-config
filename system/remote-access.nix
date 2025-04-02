{
  pkgs,
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
        output_name = 1;
      };
    };
    services.displayManager.autoLogin = {
      enable = cfg.sunshine;
      user = "pebble";
    };
    # Used so that I can access this PC remotely using Sunshine but still have a password.
    systemd.user.services.lock-if-autologin = {
      enable = cfg.sunshine;
      description = "If the display manager is set to autologin, lock on startup.";
      path = [pkgs.procps];
      script = ''
        SDDM_TEST=`pgrep -xa sddm-helper`
        [[ $SDDM_TEST == *"--autologin"* ]] && loginctl lock-session
      '';
      wantedBy = ["multi-user.target"];
      after = ["graphical-session.target"];
    };
  };
}
