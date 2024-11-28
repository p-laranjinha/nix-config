{pkgs, ...}: {
  programs.plasma = {
    enable = true;
    #overrideConfig = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };
  };
}
