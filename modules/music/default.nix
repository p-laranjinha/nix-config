{
  pkgs,
  funcs,
  vars,
  config,
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
              };
              beets-yearfixer = python-prev.buildPythonPackage rec {
                pname = "beets-yearfixer";
                version = "v0.0.5";
                pyproject = true;

                src = prev.fetchFromGitHub {
                  owner = "adamjakab";
                  repo = "BeetsPluginYearFixer";
                  rev = version;
                  hash = "sha256-TDRkCihp+hB33e9LCBpUye+KobpTPrDMutMa4zHJQ68=";
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
              };
              beets-maptag = python-prev.buildPythonPackage {
                pname = "beets-maptag";
                version = "0.0.2";
                pyproject = true;

                src = prev.fetchFromGitHub {
                  owner = "p-laranjinha";
                  repo = "beets-maptag";
                  rev = "master";
                  hash = "sha256-9LTIDsgoP6Au8Es3XZt3uj2XTPUpfLueC2klMZ1mLmk=";
                };

                build-system = with python-prev; [
                  setuptools
                ];

                nativeBuildInputs = with python-prev; [
                  beets
                ];

                passthru = {
                  updateScript = python-prev.nix-update-script {};
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
                  yearfixer = {
                    enable = true;
                    propagatedBuildInputs = [python-prev.beets-yearfixer];
                  };
                  maptag = {
                    enable = true;
                    propagatedBuildInputs = [python-prev.beets-maptag];
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
  hm.home.file.".config/beets/paths.yaml".text = let
    essentia_models = fetchTarball {
      url = "https://essentia.upf.edu/svm_models/essentia-extractor-svm_models-v2.1_beta5.tar.gz";
      sha256 = "sha256:11ps1l4h8bl4l9rlvkhjs61908l18dh7mpq65brm8ki99hnp9g64";
    };
    streaming_extractor_music = "${funcs.mkMutableConfigSymlink ./essentia/streaming_extractor_music}";
  in ''
    xtractor:
      essentia_extractor: ${streaming_extractor_music}
      extractor_profile:
        highlevel:
          svm_models:
            # https://acousticbrainz.org/datasets/accuracy
            # These have to be absolute links.
            - ${essentia_models}/danceability.history
            - ${essentia_models}/gender.history
            - ${essentia_models}/genre_rosamerica.history
            - ${essentia_models}/mood_acoustic.history
            - ${essentia_models}/mood_aggressive.history
            - ${essentia_models}/mood_electronic.history
            - ${essentia_models}/mood_happy.history
            - ${essentia_models}/mood_party.history
            - ${essentia_models}/mood_relaxed.history
            - ${essentia_models}/mood_sad.history
            - ${essentia_models}/moods_mirex.history
            - ${essentia_models}/voice_instrumental.history
            # The following aren't used by the plugin:
            # - ${essentia_models}/genre_dortmund.history
            # - ${essentia_models}/genre_electronic.history
            # - ${essentia_models}/genre_tzanetakis.history
            # - ${essentia_models}/ismir04_rhythm.history
            # - ${essentia_models}/timbre.history
            # - ${essentia_models}/tonal_atonal.history
  '';
  secrets.beets-secrets = {
    sopsFile = ./secrets.yaml;
    format = "yaml";
    key = ""; # Entire file.
    # Only the user and group can read and nothing else.
    mode = "0440";
    owner = vars.username;
  };
}
