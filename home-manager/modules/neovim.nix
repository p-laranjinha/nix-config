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
    rev = "adb18c0a361ef0fbed68aa6520ee0dd91f1a0ca5"; # HEAD
    sha256 = "1jidzriymr9m0rl2xw6ails51h0144c06c55gqwk53m130pmf74w";
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
