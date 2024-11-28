{ ... }:
{
  programs.git = {
    enable = true;
    extraConfig = {
      init.defaultBranch = "master";
    };
    userName = "p-laranjinha";
    userEmail = "plcasimiro2000@gmail.com";
  };
  programs.gh = {
    enable = true;
  };
}
