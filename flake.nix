{
  description = "flake";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # I wanted to use a stable nixpkgs, but plasma-manager had problems with it.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # So that regular binaries can be run.
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations.orange = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        umport = (import ./umport.nix {inherit (nixpkgs) lib;}).umport;
      };
      modules = [
        {nixpkgs.overlays = [inputs.nur.overlay];}
        ./system/configuration.nix
        inputs.lix-module.nixosModules.default
        inputs.nix-ld.nixosModules.nix-ld
        # https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module
        inputs.home-manager.nixosModules.default
        {
          # If the line below doesn't work run "journalctl --unit home-manager-pebble.service"
          #  to see if a file is making home-manager not able to start the systemd service on rebuild.
          home-manager.backupFileExtension = "backup";

          home-manager.extraSpecialArgs = {
            flake-inputs = inputs;
            # If we don't also add umport here, home manager has an infinite recursion error.
            umport = (import ./umport.nix {inherit (nixpkgs) lib;}).umport;
          };
          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;
          home-manager.sharedModules = [
            inputs.plasma-manager.homeManagerModules.plasma-manager
          ];
          home-manager.users.pebble.imports = [
            ./home-manager/home.nix
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
          ];
        }
      ];
    };
  };
}
