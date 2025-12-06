inputs: let
  # Setting this in 'let in' so the values can be used easier in imports.
  default = rec {
    hostname = "orange";
    username = "pebble";
    fullname = "Orange Pebble";
    homeDirectory = "/home/pebble";
    # A home inside the home directory so I'm not bothered by folders and hidden folders added by programs.
    subHomeDirectory = "${homeDirectory}/home";
    configDirectory = "${subHomeDirectory}/nix-config";
    # secretsDirectory = "${inputs.self}/secrets";
    hostPlatform = "x86_64-linux";
    # Research properly before changing this.
    stateVersion = "24.05";
  };
in
  default
