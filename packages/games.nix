{pkgs, ...}: {
  home.packages = with pkgs; [
    prismlauncher
    heroic
    cartridges

    mindustry
    osu-lazer-bin
  ];

  services.flatpak.packages = [
    "net.veloren.airshipper"
    "app.drey.MultiplicationPuzzle"
    "com.agateau.PixelWheels"
    "net.hhoney.tinycrate"
  ];
}
