{pkgs, ...}: {
  # So that regular binaries can be run.
  programs.nix-ld = {
    enable = true;
    libraries =
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
