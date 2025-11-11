{
  inputs,
  this,
  ...
}: {
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
    # https://seiarotg.github.io/quadlet-nix/home-manager-options.html
    virtualisation.quadlet = {
      autoEscape = true; # Will be default in the future.
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
              "${this.homeDirectory}/Desktop/searxng/config/:/etc/searcxng/"
              "${this.homeDirectory}/Desktop/searxng/data/:/var/cache/searcxng/"
            ];
          };
        };
      };
    };
  };
}
