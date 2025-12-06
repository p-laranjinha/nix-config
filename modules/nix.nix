{
  inputs,
  vars,
  ...
}: {
  networking.hostName = vars.hostname;
  # Don't forget to set a password with `passwd`.
  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.fullname;
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
    #     url = "file:${vars.configDirectory}";
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

  system.stateVersion = vars.stateVersion;
}
