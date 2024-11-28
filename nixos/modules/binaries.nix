{ pkgs, ... }:
{
  # So that regular binaries can be run. ".dev" so that it uses the flake repository.
  programs.nix-ld.dev.enable = true;
  programs.nix-ld.dev.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    #  here, NOT in environment.systemPackages
  ];
}
