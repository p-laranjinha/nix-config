{
  this,
  config,
  ...
}: let
  searxng-config = config.lib.meta.relativeToAbsoluteConfigPath ./config;
  searxng-data = "${this.homeDirectory}/Desktop/searxng/data";
  valkey-data = "${this.homeDirectory}/Desktop/searxng/valkey-data";
in {
  systemd.tmpfiles.rules = [
    "d ${searxng-config} 2770 ${this.username} share - -"
    "d ${searxng-data} 2770 ${this.username} share - -"
    "d ${valkey-data} 2770 ${this.username} users - -"
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
            environments = {
              FORCE_OWNERSHIP = "false";
            };
            environmentFiles = [config.secrets.searxng.path];
            volumes = [
              "${searxng-config}:/etc/searxng"
              "${searxng-data}:/var/cache/searxng"
            ];
            networks = ["searxng"];
            # userns = "nomap";
            dropCapabilities = [
              "CHOWN"
              "DAC_OVERRIDE"
              "FOWNER"
              "FSETID"
              "KILL"
              "NET_BIND_SERVICE"
              "SETFCAP"
              "SETGID"
              "SETPCAP"
              "SETUID"
              "SYS_CHROOT"
            ];
            # annotations = {"run.oci.keep_original_groups" = "1";};
            uidMaps = [
              "0:1:1000"
            ];
            gidMaps = [
              "0:2:1000"
              "1001:1:1"
            ];
            addGroups = ["1001"];
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
            volumes = ["${valkey-data}:/data"];
            networkAliases = ["valkey"];
            networks = ["searxng"];
            userns = "nomap";
            user = "valkey";
            annotations = {"run.oci.keep_original_groups" = "1";};
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
