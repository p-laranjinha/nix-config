{...}: {
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "master";
      user.name = "p-laranjinha";
      user.email = "plcasimiro2000@gmail.com";
    };
    # Git extension for versioning large files (Git Large File Storage).
    lfs.enable = true;
  };
  programs.gh = {
    enable = true;
  };
}
