{pkgs, ...}: {
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
}
