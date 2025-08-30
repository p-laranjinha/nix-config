{pkgs, ...}: {
  imports = [./vm.nix];

  environment.systemPackages = with pkgs; [
    quickemu
    gparted

    # Fonts.
    nerd-fonts.fira-code
    overpass # A nerd-fonts variant also exists.
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
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
