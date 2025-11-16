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
    "d ${searxng-data} 0740 ${this.username} users - -"
    "d ${valkey-data} 0740 ${this.username} users - -"
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
      # https://www.redhat.com/en/blog/rootless-podman-user-namespace-modes
      # I'm using 'userns="nomap"' for the most security, but that requires
      #  that volumes use the 'U' option so that the containers automatically
      #  change owner/group and can 'read from'/'write to' the volumes. But the
      #  'U' option makes it harder to edit volume files outside the containers
      #  because of the changed owner/group (requires sudo), and so I add the
      #  'copy' option to volumes where I intend to manually edit the contents,
      #  so that it copies the files on volume creation. The 'copy' option has
      #  some side-effects: changes made to the volumes by the container are
      #  forgotten on shutdown, and changes made outside the container only
      #  affect the container after it restarts.
      # https://www.redhat.com/en/blog/user-flag-rootless-containers
      # I'm also using 'user="<user>"' to make the container not use the root
      #  user, as even in rootless mode it still has more permissions. I find a
      #  valid user by running 'podman exec -it <container> /bin/sh', and then
      #  running 'cat /etc/passwd' to list all users (the best one to use is
      #  probably the last one).
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
            environmentFiles = [config.secrets.searxng.path];
            volumes = [
              "${searxng-config}:/etc/searxng:U,copy"
              "${searxng-data}:/var/cache/searxng:U"
            ];
            networks = ["searxng"];
            userns = "nomap";
            user = "searxng";
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
            volumes = ["${valkey-data}:/data:U"];
            networkAliases = ["valkey"];
            networks = ["searxng"];
            userns = "nomap";
            user = "valkey";
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
