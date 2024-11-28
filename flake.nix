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
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations.orange = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        {nixpkgs.overlays = [inputs.nur.overlay];}
        ./nixos/configuration.nix
        inputs.lix-module.nixosModules.default
        inputs.nix-ld.nixosModules.nix-ld
        inputs.home-manager.nixosModules.default
        {
          # https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module
          home-manager.backupFileExtension = "backup";
          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;
          home-manager.sharedModules = [
            inputs.plasma-manager.homeManagerModules.plasma-manager
          ];
          home-manager.users.pebble = import ./home-manager/home.nix;
        }
      ];
    };
  };
}
