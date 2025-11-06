{pkgs, ...}: {
  hm = {
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
      rev = "20fbfe2a18eb8ee9b8c5482afe1e639a9330a945"; # HEAD
      sha256 = "1mlynprn39hqp1c3dmg424x8qqmdgy0w8flq9slrsja80zky62v9";
    };
    home.shellAliases = {
      # Neovim that uses the config from my git repo.
      nvimg = "XDG_CONFIG_HOME=~/Projects NVIM_APPNAME=neovim-config nvim";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
    };
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
