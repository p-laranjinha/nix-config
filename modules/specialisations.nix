# https://wiki.nixos.org/wiki/Specialisation
# Custom options and their defaults are set on ../lib/opts/default.nix
{ ... }:
{
  specialisation = {
    sunshine.configuration = {
      opts.sunshine = true;
      opts.one-1920x1080-screen = true;
    };
    niri.configuration = {
      opts.plasma = false;
      opts.niri = true;
    };
  };
}
