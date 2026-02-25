{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.opts.niri {
    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
    programs = {
      niri = {
        enable = true;
      };
      dms-shell = {
        enable = true;
      };
      dsearch = {
        enable = true;
      };
    };
    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
    };
  };
}
