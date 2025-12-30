{pkgs, ...}: {
  # https://nixcademy.com/posts/mastering-nixpkgs-overlays-techniques-and-best-practice/
  nixpkgs.overlays = [
    (
      final: prev: {
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/pi/picard/package.nix#L86
        picard = prev.picard.overrideAttrs (finalAttrs: prevAttrs: {
          propagatedBuildInputs =
            prevAttrs.propagatedBuildInputs
            ++ (with prev.python312Packages; [
              # Dependency for BPM Analyzer.
              aubio
            ]);
        });
      }
    )
  ];

  environment.systemPackages = with pkgs; [
    # A GUI music tagger just to have it.
    picard

    # Dependency for the ReplayGain 2.0 picard plugin.
    rsgain

    # Tool to mass download lrc lyrics for tracks.
    lrcget
  ];
}
