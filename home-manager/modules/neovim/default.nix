{...}: {
  #home.file.".config/nvim".source = ./neovim-config;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    #extraLuaConfig = lib.fileContents neovim-config/init.lua;
  };
}
