{
  lib,
  pkgs,
  umport,
  ...
}: {
  imports = umport {
    path = ./.;
    exclude = [./default.nix];
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
  ];

  networking.hostName = "orange";
  # Don't forget to set a password with ‘passwd’.
  users.users.pebble = {
    isNormalUser = true;
    description = "Orange Pebble";
    extraGroups = ["networkmanager" "wheel" "wireshark"];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
  };

  networking.networkmanager.enable = true;
  # This makes the system wait for the network before booting. This also fails rebuild if enabled.
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  hardware.bluetooth = {
    enable = true;
    # Had to remove ~/.config/bluedevilglobalrc for bluetooth to be online on startup.
    # https://www.reddit.com/r/ManjaroLinux/comments/12fgj3o/kde_plasma_bluetooth_not_automatically_powered_on/
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
