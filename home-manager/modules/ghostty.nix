{flake-inputs, ...}: {
  home.packages = [
    flake-inputs.ghostty.packages.x86_64-linux.default
  ];

  home.file.".config/ghostty/config".text = ''
    theme = ayu
    font-size = 10
    font-family = "FiraCode Nerd Font"
  '';
}
