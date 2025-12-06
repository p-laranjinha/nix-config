{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

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
    vars = import ./lib/vars;
    lib = (nixpkgs.lib.extend (_: _: home-manager.lib)).extend (import ./lib/lib);

    pkgs-stable = import inputs.nixpkgs-stable {
      system = vars.hostPlatform;
      config.allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  in {
    inherit lib;
    nixosConfigurations.${vars.hostname} = nixpkgs.lib.nixosSystem {
      inherit lib;
      system = vars.hostPlatform;
      modules =
        (lib.attrValues (lib.modulesIn ./modules))
        ++ [
          ./lib/funcs
          ./lib/opts
        ];
      specialArgs = {
        inherit inputs;
        inherit vars;
        inherit pkgs-stable;
      };
    };
  };
}
