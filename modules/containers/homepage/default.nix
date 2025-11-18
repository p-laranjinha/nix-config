{
  this,
  config,
  ...
}: let
  homepage-config = config.lib.meta.relativeToAbsoluteConfigPath ./config;
  vars =
    config.vars.containers.homepage
    // {rootCapabilities = config.vars.containers.rootCapabilities;};
  funcs = config.funcs.containers;
in {
  systemd.tmpfiles.rules = [
    "d ${homepage-config} 2770 - ${vars.mainGroup} - -"
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
            user = funcs.mkUser "node" vars.mainGroup;
            uidMaps = funcs.mkUidMaps vars.n;
            gidMaps =
              funcs.mkGidMaps
              vars.n
              ([vars.mainGroup] ++ vars.groups);
            addGroups =
              funcs.mkAddGroups
              vars.groups;
          };
        };
      };
    };
  };
}
