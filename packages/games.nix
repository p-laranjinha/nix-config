{pkgs, ...}: {
  home.packages = with pkgs; [
    prismlauncher
    heroic
    cartridges
  ];
}
