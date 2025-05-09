{pkgs, ...}: {
  home.packages = with pkgs; [
    ghostty
    wezterm
  ];

  home.file.".config/ghostty/config".text = ''
    theme = ayu
    # The background color in nvim is darker, so I chose that.
    background = #0A0E14

    font-size = 11
    font-family = "FiraCode Nerd Font"
  '';
}
