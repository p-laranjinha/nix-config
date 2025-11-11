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
      autoEscape = true;
      containers = {
        echo-server = {
          autoStart = true;
          serviceConfig = {
            RestartSec = "10";
            Restart = "always";
          };
          containerConfig = {
            image = "docker.io/mendhak/http-https-echo:31";
            publishPorts = ["127.0.0.1:8080:8080"];
            userns = "keep-id";
          };
        };
      };
    };
  };
}
