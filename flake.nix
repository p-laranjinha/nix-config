{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # Common information about the system that may be used in multiple locations.
    # Using camelCase because that is the standard for options. kebab-case is for packages and files.
    this = {
      hostname = "orange";
      username = "pebble";
      fullname = "Orange Pebble";
      homeDirectory = "/home/pebble";
      # A home inside the home directory so I'm not bothered by folders and hidden folders added by programs.
      subHomeDirectory = "/home/pebble/home";
      configDirectory = "/home/pebble/home/nix-config";
      hostPlatform = "x86_64-linux";
      # Research properly before changing this.
      stateVersion = "24.05";
    };

    lib = (nixpkgs.lib.extend (_: _: home-manager.lib)).extend (import ./lib);
  in {
    inherit lib;
    nixosConfigurations.${this.hostname} = nixpkgs.lib.nixosSystem {
      inherit lib;
      modules =
        (lib.attrValues (lib.modulesIn ./modules))
        ++ [];
      specialArgs = {
        inherit inputs;
        inherit this;
      };
    };
  };
}
