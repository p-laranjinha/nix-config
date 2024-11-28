{pkgs, ...}: {
  programs.plasma = {
    enable = true;
    #overrideConfig = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };
    input.mice = [
      {
        name = "Logitech USB Receiver";
        vendorId = "046d";
        productId = "c547";
        enable = true;
        acceleration = 0;
        accelerationProfile = "none";
      }
      {
        name = "Logitech G502 X LIGHTSPEED";
        vendorId = "046d";
        productId = "c098";
        enable = true;
        acceleration = 0;
        accelerationProfile = "none";
      }
      {
        name = "Keychron Keychron K4 Pro Mouse";
        vendorId = "3434";
        productId = "0240";
        enable = true;
        acceleration = 0;
        accelerationProfile = "none";
      }
    ];
    configFile = {
      # https://www.reddit.com/r/kde/comments/r5xir0/config_file_location_for_hot_corners/
      # Disable corners and edges that do things.
      kwinrc.ElectricBorders = {
        Bottom = "None";
        BottomLeft = "None";
        BottomRight = "None";
        Left = "None";
        Right = "None";
        Top = "None";
        TopLeft = "None";
        TopRight = "None";
      };
    };
  };
}
