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
    rev = "b9b07f431377cf51968fc45fe38e952d4b713498"; # HEAD
    sha256 = "1s95fnr8mych05cqh0nxki807zc8pcxlsxbw8h32advip36s8zkp";
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
