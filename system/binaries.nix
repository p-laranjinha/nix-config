{pkgs, ...}: {
  # So that regular binaries can be run.
  # This doesn't export to LD_LIBRARY_PATH in order to not affect packages that
  #  are correctly defined.
  # For packages that are not correctly defined you may have to
  #  "export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH" before running the command.
  #  For regular commands you can create an alias, but for programs you'll need
  #   to figure out something else, maybe use flatpak instead of a package?
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs;
    # https://nixos.wiki/wiki/Games
    # https://discourse.nixos.org/t/programs-nix-ld-libraries-expects-set-instead-of-list/56009/4
    # Should make most binaries run.
      pkgs.steam-run.args.multiPkgs pkgs
      ++ [
        # Add any missing dynamic libraries for unpackaged programs
        #  here, NOT in environment.systemPackages
      ];
  };
}
