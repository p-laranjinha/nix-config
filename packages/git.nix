{...}: {
  programs.git = {
    enable = true;
    extraConfig = {
      init.defaultBranch = "master";
    };
    userName = "p-laranjinha";
    userEmail = "plcasimiro2000@gmail.com";
    # Git extension for versioning large files (Git Large File Storage).
    lfs.enable = true;
  };
  programs.gh = {
    enable = true;
  };
}
