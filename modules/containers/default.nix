{
  inputs,
  this,
  lib,
  config,
  ...
}: {
  imports =
    [inputs.quadlet-nix.nixosModules.quadlet]
    ++ lib.attrValues (lib.modulesIn ./.);
  # Enable podman & podman systemd generator.
  virtualisation.quadlet.enable = true;
  users.users.${this.username} = {
    # Required for auto start before user login.
    linger = true;
    # Required for rootless container with multiple users.
    autoSubUidGidRange = true;
    subGidRanges = [
      {
        count = 1;
        startGid = 1001;
      }
    ];
  };
  # A 'share' group for container users so they don't have to be mapped to the host user.
  users.groups.share = {
    gid = 1001;
    members = [this.username];
  };
  hm = {
    imports = [inputs.quadlet-nix.homeManagerModules.quadlet];
    virtualisation.quadlet = {
      autoEscape = true; # Will be default in the future.
    };
  };
}
# Container options:
#  https://seiarotg.github.io/quadlet-nix/home-manager-options.html
#
# Volumes don't support symlinks, so when I want to volume folders in this repo
#  it has to be directly.
#
# https://www.redhat.com/en/blog/rootless-podman-user-namespace-modes
# I'm using 'userns="nomap"' for the most security, and if I stopped here I
#  could make the volumes use the 'U' option so that the containers
#  automatically change owner/group and can 'read from'/'write to' the volumes.
# But the 'U' option makes it harder to edit volume files outside the
#  containers because of the changed owner/group (requires sudo).
#
# https://www.redhat.com/en/blog/user-flag-rootless-containers
# I'm also using 'user="<user>"' to make the container not use the root user,
#  as even in rootless mode it still has more permissions. I find a valid user
#  by running 'podman exec -it <container> cat /etc/passwd' to list all users
#  (the best one to use is probably the last one).
# For containers that need to be root to run some utils, I'll remove the user
#  option but drop root's capabilities instead. Use the following to get the
#  capabilities of the current user: 'podman top <container> capeff'
# Changing the user or removing root capabilities makes the 'U' volume option
#  stop working, which then requires sharing host groups with write permissions.
#
# https://www.redhat.com/en/blog/supplemental-groups-podman-containers
# When I want to add the host user's groups to the container's user, I'll use
#  'annotations = {"run.oci.keep_original_groups" = "1";};' instead of
#  'addGroups = ["keep-groups"]; so that I can define other groups using
#  'addGroups' if needed.
#
# I'm using 'systemd.tmpfiles.rules' to automatically create directories and
#  set their permissions. Using 2___ permissions, makes it so the files created
#  in that directory inherit the group, so I can hopefully at least read the
#  files outside the container.
