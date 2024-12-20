{...}: {
  # You may have to change the boot order in the BIOS
  #  if you change the bootloader here.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    systemd-boot.enable = false;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      #useOSProber = true;
    };
  };
}
