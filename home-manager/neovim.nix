{pkgs, ...}: {
  home.packages = with pkgs; [
    # Dependencies
    gcc
    unzip # Used to install LSPs with Mason.
    ripgrep
    fzf
    cargo # Used to install the nil nix LSP.
    wl-clipboard # Clipboard provider for Wayland.
    xclip # Clipboard provider for X11/RDP
  ];
  home.file.".config/nvim".source = pkgs.fetchgit {
    url = "https://github.com/p-laranjinha/neovim-config";
    rev = "40e9bd58c8accdc9a54a4a36ad672dac420ff886"; # HEAD
    sha256 = "1gkjszn2afwr8c4nm74gch8hqgvfbng6icgwchzmbxwd3csqyaik";
  };
  home.shellAliases = {
    # Neovim that uses the config from my git repo.
    nvimg = "XDG_CONFIG_HOME=~/Projects NVIM_APPNAME=neovim-config nvim";
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
