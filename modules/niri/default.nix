{
  lib,
  config,
  pkgs,
  funcs,
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
    hm.home.file.".config/niri".source = funcs.mkMutableConfigSymlink ./config;
  };
}
