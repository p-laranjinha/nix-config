{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Bootloader
    ./modules/boot.nix

    # Filesystem config and btrfs snapshots.
    ./modules/fs.nix

    # Wayland and X11.
    ./modules/display.nix

    # Timezones and regions.
    ./modules/time.nix

    # Pipewire and other audio things.
    ./modules/audio.nix

    # Everything required to remote access this host:
    #  - Wake-on-lan
    #  - Tailscale
    #  - xRDP
    #  - SSH
    #  - Sunshine
    #    - Autologin and lock
    ./modules/remote-access.nix

    # Allows regular binaries to be run.
    ./modules/binaries.nix

    # System packages and NixOS programs.
    ./modules/packages.nix
  ];

  networking.hostName = "orange";
  # Don't forget to set a password with ‘passwd’.
  users.users.pebble = {
    isNormalUser = true;
    description = "Orange Pebble";
    extraGroups = ["networkmanager" "wheel" "wireshark"];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
