{this, ...}: let
  searxng-config = "${this.homeDirectory}/Desktop/searxng/config/";
  searxng-data = "${this.homeDirectory}/Desktop/searxng/data/";
  valkey-data = "${this.homeDirectory}/Desktop/searxng/valkey-data/";
in {
  # Make sure the volume directories are created.
  systemd.tmpfiles.rules = [
    "d ${searxng-config} 0770 ${this.username} users - -"
    "d ${searxng-data} 0770 ${this.username} users - -"
    "d ${valkey-data} 0770 ${this.username} users - -"
  ];
  networking.firewall.allowedTCPPorts = [8080];
  hm = {
    # https://seiarotg.github.io/quadlet-nix/home-manager-options.html
    virtualisation.quadlet = {
      containers = {
        searxng = {
          autoStart = true;
          serviceConfig = {
            RestartSec = "10";
            Restart = "always";
          };
          containerConfig = {
            image = "docker.io/searxng/searxng:latest";
            publishPorts = ["8080:8080"];
            volumes = [
              "${searxng-config}:/etc/searcxng/"
              "${searxng-data}:/var/cache/searcxng/"
            ];
            networks = [
              "searxng"
            ];
          };
        };
        searxng-valkey = {
          autoStart = true;
          serviceConfig = {
            RestartSec = "10";
            Restart = "always";
          };
          containerConfig = {
            image = "docker.io/valkey/valkey:8-alpine";
            exec = "valkey-server --save 30 1 --loglevel warning";
            volumes = [
              "${valkey-data}:/data/"
            ];
            networks = [
              "searxng"
            ];
            networkAliases = [
              "valkey"
            ];
          };
        };
      };
      networks = {
        searxng = {};
      };
    };
  };
}
