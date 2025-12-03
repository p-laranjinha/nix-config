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

  security.sudo.extraConfig = ''
    Defaults pwfeedback # Shows asterisks when typing password.
  '';

  # Sets the configuration revision string to either the git commit reference or 'dirty'.
  # Can be seen on entries shown by 'nixos-rebuild list-generations'.
  system.configurationRevision = inputs.self.rev or "dirty";

  nix.settings.experimental-features = ["nix-command" "flakes"];

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
