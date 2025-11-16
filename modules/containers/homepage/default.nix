{
  this,
  config,
  ...
}: let
  homepage-config = config.lib.meta.relativeToAbsoluteConfigPath ./config;
in {
  systemd.tmpfiles.rules = [
    "d ${homepage-config} 2770 ${this.username} users - -"
  ];
  # Required to run homepage in rootless mode and it being able to read containers.
  users.users.${this.username}.extraGroups = ["podman"];
  networking.firewall.allowedTCPPorts = [3000];
  hm = {
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
            userns = "nomap";
            user = "node";
            annotations = {"run.oci.keep_original_groups" = "1";};
          };
        };
      };
    };
  };
}
