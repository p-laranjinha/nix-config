# https://wiki.nixos.org/wiki/Specialisation
# Custom options and their defaults are set on ../lib/opts/default.nix
{ ... }:
{
  specialisation = {
    sunshine.configuration = {
      opts = {
        sunshine = true;
        one-1920x1080-screen = true;
        plasma = true;
        niri = false;
      };
    };
    plasma.configuration = {
      opts = {
        plasma = true;
        niri = false;
      };
    };
  };
}
