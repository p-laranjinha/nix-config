{
  this,
  config,
  ...
}: let
  # Volumes don't support symlinks so this one will be inside this repo.
  homepage-config = config.lib.meta.relativeToAbsoluteConfigPath ./config;
in {
  # Required to run homepage in rootless mode and it being able to read containers.
  users.users.${this.username}.extraGroups = ["docker"];
  networking.firewall.allowedTCPPorts = [3000];
  hm = {
    # https://seiarotg.github.io/quadlet-nix/home-manager-options.html
    virtualisation.quadlet = {
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
      # I'm also using 'user="<user>"' to make the container not use the root
      #  user, as even in rootless mode it still has more permissions. I find a
      #  valid user by running 'podman exec -it <container> /bin/sh', and then
      #  running 'cat /etc/passwd' to list all users (the best one to use is
      #  probably the last one).
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
              # Maybe I should volume each file individually so I can have permanent logs.
              "${homepage-config}:/app/config:U,copy"
              "/run/user/1000/podman/podman.sock:/var/run/podman.sock"
            ];
            userns = "nomap";
            user = "node";
          };
        };
      };
    };
  };
}
