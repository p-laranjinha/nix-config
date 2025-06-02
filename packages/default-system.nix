{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    quickemu
  ];
  virtualisation.spiceUSBRedirection.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
  ];

  # Required to install flatpak
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
    extraPortals = with pkgs; [
      # xdg-desktop-portal-wlr
      kdePackages.xdg-desktop-portal-kde
      # xdg-desktop-portal-gtk
    ];
  };
  # install flatpak binary
  services.flatpak.enable = true;

  environment.etc."paperless-admin-pass".text = "admin";
  services.paperless = {
    enable = true;
    passwordFile = "/etc/paperless-admin-pass";
    settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_LANGUAGE = "por";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [28981];
}
