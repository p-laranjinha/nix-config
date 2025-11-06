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

    # Accept all traffic from Tailscale unconditionally
    networking.firewall.trustedInterfaces = ["tailscale0"];

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
      applications = {
        env = {
          PATH = "$(PATH):$(HOME)/.local/bin";
        };
        apps = [
          {
            name = "Desktop 1080p 60fps";
            image-path = "desktop.png";
            prep-cmd = [
              {
                do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-2.mode.1920x1080@60";
                undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-2.mode.2560x1440@165";
              }
            ];
          }
          {
            name = "Steam Big Picture 1080p 60fps";
            image-path = "steam.png";
            detached = [
              "setsid steam steam://open/bigpicture"
            ];
            prep-cmd = [
              {
                do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-2.mode.1920x1080@60";
                undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-2.mode.2560x1440@165";
              }
            ];
          }
          {
            name = "Desktop";
            image-path = "desktop.png";
          }
          {
            name = "Steam Big Picture";
            image-path = "steam.png";
            detached = [
              "setsid steam steam://open/bigpicture"
            ];
          }
        ];
      };
    };
    services.displayManager.autoLogin = {
      # There is an autostart script somewhere else that locks on autologin.
      enable = cfg.sunshine;
      user = "pebble";
    };
  };
}
