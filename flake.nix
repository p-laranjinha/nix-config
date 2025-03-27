{
  description = "flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # plasma-manager currently requires nixos unstable :(
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    ghostty.url = "github:ghostty-org/ghostty";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = {self, ...} @ inputs: {
    nixosConfigurations.orange = inputs.nixpkgs.lib.nixosSystem rec {
      # These values are added as arguments to all modules.
      specialArgs = {
        inherit inputs;
        umport = (import ./lib/umport.nix {inherit (inputs.nixpkgs) lib;}).umport;
      };
      modules = [
        ./system
        inputs.home-manager.nixosModules.default
        {
          # Home manager doesn't use specialArgs to add arguments to its modules.
          home-manager.extraSpecialArgs = {} // specialArgs;

          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;

          home-manager.sharedModules = [
            inputs.plasma-manager.homeManagerModules.plasma-manager
          ];

          home-manager.users.pebble.imports = [
            ./home
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
          ];

          # This allows home manager to overwrite files by backing them up with the following extension.
          home-manager.backupFileExtension = "backup";
        }
        inputs.nur.modules.nixos.default
      ];
    };
  };
}
