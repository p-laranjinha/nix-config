{pkgs, ...}: {
  home.file.".config/nvim".source = pkgs.fetchgit {
    url = "https://github.com/p-laranjinha/neovim-config";
    sha256 = "sha256-O2HeUy1BHcufYcUmeI9jO0KT9xuFGRXW7ILZ7sel7C4=";
  };
  home.shellAliases = {
    nvimu = "nvim -u ~/Programs/neovim-config/init.lua";
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    #extraLuaConfig = lib.fileContents neovim-config/init.lua;
  };
}
