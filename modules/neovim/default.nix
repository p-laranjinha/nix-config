{
  pkgs,
  funcs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Dependencies
    gcc
    unzip # Used to install LSPs with Mason.
    ripgrep
    fzf
    cargo # Used to install the nil nix LSP.
    wl-clipboard # Clipboard provider for Wayland.
    xclip # Clipboard provider for X11/RDP
    nodejs_24 # For the bash LSP.
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };
  hm = {
    home.file.".config/nvim".source = funcs.mkMutableConfigSymlink ./config;
  };
  environment.shellAliases = {
    vi2 = "vi -u '~/home/projects/neovim-config/init.lua'";
    vim2 = "vim -u '~/home/projects/neovim-config/init.lua'";
    nvim2 = "nvim -u '~/home/projects/neovim-config/init.lua'";
  };
}
