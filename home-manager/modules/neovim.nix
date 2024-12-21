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
    rev = "b0cd74b9baeb7f6f0969b41a61c417b5ae5e5958"; # HEAD
    sha256 = "1fdgs4730pxqm6ynj1ppp174h8v0l0l769rc18dx86j5p1l0n50j";
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
