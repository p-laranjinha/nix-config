{
  this,
  config,
  ...
}: let
  # Volumes don't support symlinks so this one will be inside this repo.
  homepage-config = config.lib.meta.relativeToAbsoluteConfigPath ./config;
in {
  networking.firewall.allowedTCPPorts = [3000];
  hm = {
    # https://seiarotg.github.io/quadlet-nix/home-manager-options.html
    virtualisation.quadlet = {
      containers = {
        homepage = {
          autoStart = true;
          serviceConfig = {
            RestartSec = "10";
            Restart = "always";
          };
          containerConfig = {
            image = "ghcr.io/gethomepage/homepage:latest";
            publishPorts = ["3000:3000"];
            volumes = [
              "${homepage-config}:/app/config"
              "/run/user/1000/podman/podman.sock:/var/run/podman.sock"
            ];
            userns = "keep-id";
          };
        };
      };
    };
  };
}
