{pkgs, ...}: {
  home.packages = with pkgs; [
    prismlauncher
    heroic
    cartridges

    mindustry
  ];

  services.flatpak.packages = [
    "net.veloren.airshipper"
    "app.drey.MultiplicationPuzzle"
    "com.agateau.PixelWheels"
    "net.hhoney.tinycrate"
  ];
}
