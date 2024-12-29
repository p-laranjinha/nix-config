{flake-inputs, ...}: {
  home.packages = [
    flake-inputs.ghostty.packages.x86_64-linux.default
  ];

  home.file.".config/ghostty/config".text = ''
    theme = tokyonight
    font-size = 11
    font-family = "FiraCode Nerd Font"
  '';
}
