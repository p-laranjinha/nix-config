{
  pkgs,
  inputs,
  ...
}: {
  # https://nixos.wiki/wiki/Virt-manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["pebble"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  # Some virt-manager configuration is in ./default-home.nix

  # https://github.com/winapps-org/winapps
  users.users.pebble.extraGroups = ["kvm" "libvirtd"];
  environment.systemPackages = [
    pkgs.freerdp
    inputs.winapps.packages."x86_64-linux".winapps
    inputs.winapps.packages."x86_64-linux".winapps-launcher # optional
  ];
  # Some winapps configuration is in ./default-home.nix
  # I had to install winapps system wide because of permission problems
  #  then move the .desktop files from /usr/share/applications/ to the regular place.
}
