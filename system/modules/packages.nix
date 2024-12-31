{pkgs, ...}: {
  # Add environment packages and NixOS programs not in home-manager here.

  environment.systemPackages = with pkgs; [];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
  ];
}
