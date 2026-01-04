{
  pkgs,
  funcs,
  vars,
  lib,
  ...
}: {
  # https://nixcademy.com/posts/mastering-nixpkgs-overlays-techniques-and-best-practice/
  nixpkgs.overlays = [
    (
      final: prev: {
        # https://nixos.org/manual/nixpkgs/unstable/#how-to-override-a-python-package-for-all-python-versions-using-extensions
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/python-modules/beetcamp/default.nix
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/python-modules/beets-audible/default.nix
        # https://github.com/NixOS/nixpkgs/pull/471166
        # https://github.com/9999years/nixpkgs/blob/185e8e16f746a975245c3aa904002d63c944f584/pkgs/development/python-modules/beets/default.nix#L481-L496
        pythonPackagesExtensions =
          prev.pythonPackagesExtensions
          ++ [
            (python-final: python-prev: {
              # To overwrite instead of creating a new package:
              # fee = python-prev.foo.overridePythonAttrs (oldAttrs: rec {
              beets-xtractor = python-prev.buildPythonPackage rec {
                pname = "beets-xtractor";
                version = "v0.4.2";
                pyproject = true;

                src = prev.fetchFromGitHub {
                  owner = "adamjakab";
                  repo = "BeetsPluginXtractor";
                  rev = version;
                  hash = "sha256-it4qQ2OS4qBEaGLJK8FVGpjlvg0MQICazV7TAM8lH9s=";
                };

                build-system = with python-prev; [
                  setuptools
                  poetry-core
                ];

                nativeBuildInputs = with python-prev; [
                  beets
                ];

                passthru = {
                  updateScript = python-prev.nix-update-script {};
                };

                meta = {
                  description = "A beets plugin to add low and high level musical information to songs.";
                  homepage = "https://github.com/adamjakab/BeetsPluginXtractor";
                  license = python-prev.lib.licenses.mit;
                  maintainers = [];
                };
              };
            })
            (python-final: python-prev: {
              beets = python-prev.beets.override {
                pluginOverrides = {
                  xtractor = {
                    enable = true;
                    propagatedBuildInputs = [python-prev.beets-xtractor];
                  };
                };
              };
            })
          ];
      }
    )
  ];

  environment.systemPackages = with pkgs; [
    # A GUI music tagger.
    picard

    # Dependency for the ReplayGain 2.0 picard plugin.
    rsgain

    # Tool to mass download lrc lyrics for tracks.
    lrcget

    # A TUI music tagger.
    beets
  ];

  # I need to use hm...initExtra so the command has autocompletion available.
  hm.programs.bash.initExtra = ''
    eval "$(beet completion)"
  '';

  environment.shellAliases = {
    # I couldn't figure out how to actually install this binary, so I just
    #  created an alias to it.
    # I tried making a derivation using the repo but it was missing libraries
    #  and I couldn't figure out how to solve it.
    streaming_extractor_music = "${funcs.mkMutableConfigSymlink ./essentia/streaming_extractor_music}";
  };

  # Docs: https://beets.readthedocs.io/en/stable/
  # Run `beet config -e` to edit this file.
  hm.home.file.".config/beets/config.yaml".source = funcs.mkMutableConfigSymlink ./beets.yaml;
}
