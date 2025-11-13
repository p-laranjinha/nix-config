{
  inputs,
  this,
  lib,
  ...
}: {
  imports =
    [inputs.quadlet-nix.nixosModules.quadlet]
    ++ lib.attrValues (lib.modulesIn ./.);
  # Enable podman & podman systemd generator.
  virtualisation.quadlet.enable = true;
  users.users.${this.username} = {
    # Required for auto start before user login.
    linger = true;
    # Required for rootless container with multiple users.
    autoSubUidGidRange = true;
  };
  hm = {
    imports = [inputs.quadlet-nix.homeManagerModules.quadlet];
    virtualisation.quadlet = {
      autoEscape = true; # Will be default in the future.
    };
  };
}
