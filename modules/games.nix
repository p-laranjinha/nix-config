{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    prismlauncher
    heroic
    cartridges

    mindustry
    osu-lazer-bin
  ];

  hm = {
    services.flatpak.packages = [
      "net.veloren.airshipper"
      "app.drey.MultiplicationPuzzle"
      "com.agateau.PixelWheels"
      "net.hhoney.tinycrate"
    ];
  };
}
