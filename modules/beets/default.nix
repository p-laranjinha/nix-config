# https://github.com/beetbox/beets
# A terminal music tagger.
{
  pkgs,
  funcs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    beets
    # python313Packages.beetcamp
    essentia-extractor
    ffmpeg

    # A separate tool to calculate ReplayGain 2.0. Feels easier than using a
    #  beets plugin.
    rsgain

    # A GUI music tagger just to have it.
    picard
  ];

  # Docs: https://beets.readthedocs.io/en/stable/
  # Run `beet config -e` to edit this file.
  hm.home.file.".config/beets/config.yaml".source = funcs.mkMutableConfigSymlink ./config.yaml;
}
