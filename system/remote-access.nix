{pkgs, ...}: let
  ENABLE_SUNSHINE = false;
in {
  networking.interfaces.enp14s0.wakeOnLan.enable = true;

  services.tailscale.enable = true;

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
  services.xrdp.openFirewall = true;

  environment.systemPackages = [
    # pkgs.kdePackages.krdp
    # pkgs.kdePackages.krfb
  ];
  # networking.firewall.allowedTCPPorts = [22 3389];
  # networking.firewall.allowedTCPPorts = [22 5900];

  # networking.firewall.allowedTCPPorts = [22];
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
    enable = ENABLE_SUNSHINE;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      output_name = 1;
    };
  };
  services.displayManager.autoLogin = {
    enable = ENABLE_SUNSHINE;
    user = "pebble";
  };
  # Used so that I can access this PC remotely using Sunshine but still have a password.
  systemd.user.services.lock-if-autologin = {
    enable = ENABLE_SUNSHINE;
    description = "If the display manager is set to autologin, lock on startup.";
    path = [pkgs.procps];
    script = ''
      SDDM_TEST=`pgrep -xa sddm-helper`
      [[ $SDDM_TEST == *"--autologin"* ]] && loginctl lock-session
    '';
    wantedBy = ["multi-user.target"];
    after = ["graphical-session.target"];
  };
}
