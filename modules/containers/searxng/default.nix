{
  this,
  config,
  ...
}: let
  # Volumes don't support symlinks so this one will be inside this repo.
  searxng-config = config.lib.meta.relativeToAbsoluteConfigPath ./config;
  searxng-data = "${this.homeDirectory}/Desktop/searxng/data";
  valkey-data = "${this.homeDirectory}/Desktop/searxng/valkey-data";
in {
  # Make sure the volume directories are created.
  systemd.tmpfiles.rules = [
    "d ${searxng-data} 0770 ${this.username} users - -"
    "d ${valkey-data} 0770 ${this.username} users - -"
  ];
  secrets.searxng = {
    sopsFile = ./secrets.env;
    format = "dotenv";
    # Entire file.
    key = "";
    # Only the user can read and nothing else.
    mode = "0400";
    owner = this.username;
  };
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
            environmentFiles = [
              config.secrets.searxng.path
            ];
            volumes = [
              "${searxng-config}:/etc/searxng:rw"
              "${searxng-data}:/var/cache/searxng:rw"
            ];
            networks = [
              "searxng"
            ];
            userns = "keep-id";
          };
        };
        searxng-valkey = {
          autoStart = true;
          serviceConfig = {
            RestartSec = "10";
            Restart = "always";
          };
          containerConfig = {
            image = "docker.io/valkey/valkey:latest";
            exec = "valkey-server --save 30 1 --loglevel warning";
            volumes = [
              "${valkey-data}:/data:rw"
            ];
            networkAliases = [
              "valkey"
            ];
            networks = [
              "searxng"
            ];
            userns = "keep-id";
          };
        };
        # https://github.com/searx/searx/discussions/1723#discussioncomment-832494
        # searxng-tor = {
        #   autoStart = true;
        #   serviceConfig = {
        #     RestartSec = "10";
        #     Restart = "always";
        #   };
        #   containerConfig = {
        #     image = "docker.io/osminogin/tor-simple:latest";
        #     networkAliases = [
        #       "tor"
        #     ];
        #     networks = [
        #       "searxng"
        #     ];
        #     userns = "keep-id";
        #   };
        # };
      };
      networks = {
        searxng = {};
      };
    };
  };
}
