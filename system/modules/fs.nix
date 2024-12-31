{...}: {
  # https://nixos.wiki/wiki/Btrfs
  fileSystems = {
    "/".options = ["compress=zstd"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
    "/swap".options = ["noatime"];
  };
  swapDevices = [{device = "/swap/swapfile";}];
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };

  services.snapper.configs = {
    # root is the default config name
    # This required "sudo btrfs subvolume create /home/.snapshots" to be run once
    root = {
      SUBVOLUME = "/home";
      ALLOW_USERS = ["pebble"];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
    };
  };
}
