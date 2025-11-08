{
  this,
  inputs,
  ...
}: {
  networking.hostName = this.hostname;
  # Don't forget to set a password with `passwd`.
  users.users.${this.username} = {
    isNormalUser = true;
    description = this.fullname;
    extraGroups = ["networkmanager" "wheel" "wireshark" "dialout"];
  };

  nix.package = inputs.determinate.packages.${this.hostPlatform}.default;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
  };

  nix.optimise = {
    # Cleans the store
    automatic = true;
    dates = ["weekly"];
  };
  nix.gc = {
    # Deletes old generations
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  services.printing.enable = true;

  # Adds current flake to the registry so it can be accessed in things like the repl.
  nix.registry = {
    config.flake = inputs.self;
    # config-git = {
    #   exact = false;
    #   to = {
    #     type = "git";
    #     url = "file:${this.configDirectory}";
    #   };
    # };
    # config-github = {
    #   exact = false;
    #   to = {
    #     type = "github";
    #     owner = "p-laranjinha";
    #     repo = "nix-config";
    #   };
    # };
  };

  system.stateVersion = this.stateVersion;
}
