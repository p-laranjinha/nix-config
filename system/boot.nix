{pkgs, ...}: {
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    systemd-boot.enable = false;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };
  environment.systemPackages = with pkgs; [
    grub2 # Makes grub commands available in the terminal.
  ];
}
