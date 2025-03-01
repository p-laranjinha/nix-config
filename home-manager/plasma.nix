{...}: {
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    # https://github.com/nix-community/plasma-manager/blob/trunk/examples/home.nix
    panels = [
      {
        location = "bottom";
        height = 44;
        screen = 0;
        widgets = [
          {
            panelSpacer = {
              expanding = false;
              length = 600;
            };
          }
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "nix-snowflake-white";
              sidebarPosition = "right";
              showActionButtonCaptions = false;
              showButtonsFor = "powerAndSession";
            };
          }
          {
            iconTasks = {
              launchers = [
                # "applications:org.kde.dolphin.desktop"
                # "applications:org.kde.konsole.desktop"
              ];
            };
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
              ];
              hidden = [];
            };
          }
          {
            digitalClock = {
              calendar.firstDayOfWeek = "sunday";
              time.format = "24h";
            };
          }
        ];
      }
    ];

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
    powerdevil.AC = {
      autoSuspend = {
        action = "nothing";
      };
      dimDisplay = {
        enable = false;
      };
      turnOffDisplay = {
        idleTimeout = "never";
        idleTimeoutWhenLocked = null;
      };
      whenSleepingEnter = "hybridSleep";
      powerProfile = "performance";
    };
    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    configFile = {
      # https://www.reddit.com/r/kde/comments/r5xir0/config_file_location_for_hot_corners/
      # Disable corners and edges that do things.
      # Change settings and look into ~/.config/kwinrc to see what does what.
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
      kwinrc.Effect-overview = {
        BorderActivate = 9;
      };

      # Disable auto lock.
      kscreenlockerrc.Daemon = {
        Autolock = false;
        Timeout = 0;
        #LockGrace = 30;
        LockOnResume = true;
      };

      # Fix bluetooth not being online on startup.
      bluedevilglobalrc.Adapters = {
        "F0:A6:54:4F:22:E0_powered" = true;
      };

      # Make max volume go to 150% and volume step to 2%.
      plasmaparc.General = {
        RaiseMaximumVolume = true;
        VolumeStep = 2;
      };
    };
  };
}
