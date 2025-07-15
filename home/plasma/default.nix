{...}: {
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      enableMiddleClickPaste = false;
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
    shortcuts = {
      # "<section>"."<key>" = [ "<shortcut1>" "<shortcut2>" "<others>" ]
      #  in kglobalshortcutssrc turns into
      #   <key>=<shortcut1>\t<shortcut2>\r<others>
      "kwin" = {
        "Window Fullscreen" = "Alt+F11,,Make Window Fullscreen";
      };

      # Default shortcuts below obtained by running rc2nix:
      #  nix run github:nix-community/plasma-manager
      "ActivityManager"."switch-to-activity-1043b150-93c2-4741-a89b-f6f92ebc92ea" = [];
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";
      "kaccess"."Toggle Screen Reader On and Off" = "Meta+Alt+S";
      "kcm_touchpad"."Disable Touchpad" = "Touchpad Off";
      "kcm_touchpad"."Enable Touchpad" = "Touchpad On";
      "kcm_touchpad"."Toggle Touchpad" = ["Touchpad Toggle" "" "Meta+Ctrl+Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku,Touchpad Toggle" "Touchpad Toggle" "Meta+Ctrl+Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku"];
      "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."decrease_volume_small" = "Shift+Volume Down";
      "kmix"."increase_microphone_volume" = "Microphone Volume Up";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."increase_volume_small" = "Shift+Volume Up";
      "kmix"."mic_mute" = ["Microphone Mute" "Meta+Volume Mute,Microphone Mute" "Meta+Volume Mute,Mute Microphone"];
      "kmix"."mute" = "Volume Mute";
      "ksmserver"."Halt Without Confirmation" = [];
      "ksmserver"."Lock Session" = ["Meta+L" "Screensaver,Meta+L" "Screensaver,Lock Session"];
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
      "ksmserver"."Log Out Without Confirmation" = [];
      "ksmserver"."LogOut" = [];
      "ksmserver"."Reboot" = [];
      "ksmserver"."Reboot Without Confirmation" = [];
      "ksmserver"."Shut Down" = [];
      "kwin"."Activate Window Demanding Attention" = "Meta+Ctrl+A";
      "kwin"."Cycle Overview" = [];
      "kwin"."Cycle Overview Opposite" = [];
      "kwin"."Decrease Opacity" = [];
      "kwin"."Edit Tiles" = "Meta+T";
      "kwin"."Expose" = "Ctrl+F9";
      "kwin"."ExposeAll" = ["Ctrl+F10" "Launch (C),Ctrl+F10" "Launch (C),Toggle Present Windows (All desktops)"];
      "kwin"."ExposeClass" = "Ctrl+F7";
      "kwin"."ExposeClassCurrentDesktop" = [];
      "kwin"."Grid View" = "Meta+G";
      "kwin"."Increase Opacity" = [];
      "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      "kwin"."Move Tablet to Next Output" = [];
      "kwin"."MoveMouseToCenter" = "Meta+F6";
      "kwin"."MoveMouseToFocus" = "Meta+F5";
      "kwin"."MoveZoomDown" = [];
      "kwin"."MoveZoomLeft" = [];
      "kwin"."MoveZoomRight" = [];
      "kwin"."MoveZoomUp" = [];
      "kwin"."Overview" = "Meta+W";
      "kwin"."Setup Window Shortcut" = [];
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."Switch One Desktop Down" = "Meta+Ctrl+Down";
      "kwin"."Switch One Desktop Up" = "Meta+Ctrl+Up";
      "kwin"."Switch One Desktop to the Left" = "Meta+Ctrl+Left";
      "kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right";
      "kwin"."Switch Window Down" = "Meta+Alt+Down";
      "kwin"."Switch Window Left" = "Meta+Alt+Left";
      "kwin"."Switch Window Right" = "Meta+Alt+Right";
      "kwin"."Switch Window Up" = "Meta+Alt+Up";
      "kwin"."Switch to Desktop 1" = "Ctrl+F1";
      "kwin"."Switch to Desktop 10" = [];
      "kwin"."Switch to Desktop 11" = [];
      "kwin"."Switch to Desktop 12" = [];
      "kwin"."Switch to Desktop 13" = [];
      "kwin"."Switch to Desktop 14" = [];
      "kwin"."Switch to Desktop 15" = [];
      "kwin"."Switch to Desktop 16" = [];
      "kwin"."Switch to Desktop 17" = [];
      "kwin"."Switch to Desktop 18" = [];
      "kwin"."Switch to Desktop 19" = [];
      "kwin"."Switch to Desktop 2" = "Ctrl+F2";
      "kwin"."Switch to Desktop 20" = [];
      "kwin"."Switch to Desktop 3" = "Ctrl+F3";
      "kwin"."Switch to Desktop 4" = "Ctrl+F4";
      "kwin"."Switch to Desktop 5" = [];
      "kwin"."Switch to Desktop 6" = [];
      "kwin"."Switch to Desktop 7" = [];
      "kwin"."Switch to Desktop 8" = [];
      "kwin"."Switch to Desktop 9" = [];
      "kwin"."Switch to Next Desktop" = [];
      "kwin"."Switch to Next Screen" = [];
      "kwin"."Switch to Previous Desktop" = [];
      "kwin"."Switch to Previous Screen" = [];
      "kwin"."Switch to Screen 0" = [];
      "kwin"."Switch to Screen 1" = [];
      "kwin"."Switch to Screen 2" = [];
      "kwin"."Switch to Screen 3" = [];
      "kwin"."Switch to Screen 4" = [];
      "kwin"."Switch to Screen 5" = [];
      "kwin"."Switch to Screen 6" = [];
      "kwin"."Switch to Screen 7" = [];
      "kwin"."Switch to Screen Above" = [];
      "kwin"."Switch to Screen Below" = [];
      "kwin"."Switch to Screen to the Left" = [];
      "kwin"."Switch to Screen to the Right" = [];
      "kwin"."Toggle Night Color" = [];
      "kwin"."Toggle Window Raise/Lower" = [];
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      "kwin"."Walk Through Windows Alternative" = [];
      "kwin"."Walk Through Windows Alternative (Reverse)" = [];
      "kwin"."Walk Through Windows of Current Application" = "Alt+`";
      "kwin"."Walk Through Windows of Current Application (Reverse)" = "Alt+~";
      "kwin"."Walk Through Windows of Current Application Alternative" = [];
      "kwin"."Walk Through Windows of Current Application Alternative (Reverse)" = [];
      "kwin"."Window Above Other Windows" = [];
      "kwin"."Window Below Other Windows" = [];
      "kwin"."Window Close" = "Alt+F4";
      "kwin"."Window Custom Quick Tile Bottom" = [];
      "kwin"."Window Custom Quick Tile Left" = [];
      "kwin"."Window Custom Quick Tile Right" = [];
      "kwin"."Window Custom Quick Tile Top" = [];
      "kwin"."Window Grow Horizontal" = [];
      "kwin"."Window Grow Vertical" = [];
      "kwin"."Window Lower" = [];
      "kwin"."Window Maximize" = "Meta+PgUp";
      "kwin"."Window Maximize Horizontal" = [];
      "kwin"."Window Maximize Vertical" = [];
      "kwin"."Window Minimize" = "Meta+PgDown";
      "kwin"."Window Move" = [];
      "kwin"."Window Move Center" = [];
      "kwin"."Window No Border" = [];
      "kwin"."Window On All Desktops" = [];
      "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      "kwin"."Window One Screen Down" = [];
      "kwin"."Window One Screen Up" = [];
      "kwin"."Window One Screen to the Left" = [];
      "kwin"."Window One Screen to the Right" = [];
      "kwin"."Window Operations Menu" = "Alt+F3";
      "kwin"."Window Pack Down" = [];
      "kwin"."Window Pack Left" = [];
      "kwin"."Window Pack Right" = [];
      "kwin"."Window Pack Up" = [];
      "kwin"."Window Quick Tile Bottom" = "Meta+Down";
      "kwin"."Window Quick Tile Bottom Left" = [];
      "kwin"."Window Quick Tile Bottom Right" = [];
      "kwin"."Window Quick Tile Left" = "Meta+Left";
      "kwin"."Window Quick Tile Right" = "Meta+Right";
      "kwin"."Window Quick Tile Top" = "Meta+Up";
      "kwin"."Window Quick Tile Top Left" = [];
      "kwin"."Window Quick Tile Top Right" = [];
      "kwin"."Window Raise" = [];
      "kwin"."Window Resize" = [];
      "kwin"."Window Shade" = [];
      "kwin"."Window Shrink Horizontal" = [];
      "kwin"."Window Shrink Vertical" = [];
      "kwin"."Window to Desktop 1" = [];
      "kwin"."Window to Desktop 10" = [];
      "kwin"."Window to Desktop 11" = [];
      "kwin"."Window to Desktop 12" = [];
      "kwin"."Window to Desktop 13" = [];
      "kwin"."Window to Desktop 14" = [];
      "kwin"."Window to Desktop 15" = [];
      "kwin"."Window to Desktop 16" = [];
      "kwin"."Window to Desktop 17" = [];
      "kwin"."Window to Desktop 18" = [];
      "kwin"."Window to Desktop 19" = [];
      "kwin"."Window to Desktop 2" = [];
      "kwin"."Window to Desktop 20" = [];
      "kwin"."Window to Desktop 3" = [];
      "kwin"."Window to Desktop 4" = [];
      "kwin"."Window to Desktop 5" = [];
      "kwin"."Window to Desktop 6" = [];
      "kwin"."Window to Desktop 7" = [];
      "kwin"."Window to Desktop 8" = [];
      "kwin"."Window to Desktop 9" = [];
      "kwin"."Window to Next Desktop" = [];
      "kwin"."Window to Next Screen" = "Meta+Shift+Right";
      "kwin"."Window to Previous Desktop" = [];
      "kwin"."Window to Previous Screen" = "Meta+Shift+Left";
      "kwin"."Window to Screen 0" = [];
      "kwin"."Window to Screen 1" = [];
      "kwin"."Window to Screen 2" = [];
      "kwin"."Window to Screen 3" = [];
      "kwin"."Window to Screen 4" = [];
      "kwin"."Window to Screen 5" = [];
      "kwin"."Window to Screen 6" = [];
      "kwin"."Window to Screen 7" = [];
      "kwin"."disableInputCapture" = "Meta+Shift+Esc";
      "kwin"."view_actual_size" = "Meta+0";
      "kwin"."view_zoom_in" = ["Meta++" "Meta+=,Meta++" "Meta+=,Zoom In"];
      "kwin"."view_zoom_out" = "Meta+-";
      "mediacontrol"."mediavolumedown" = [];
      "mediacontrol"."mediavolumeup" = [];
      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = "Media Pause";
      "mediacontrol"."playmedia" = [];
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";
      "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
      "org_kde_powerdevil"."Hibernate" = "Hibernate";
      "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
      "org_kde_powerdevil"."PowerDown" = "Power Down";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "Sleep";
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "org_kde_powerdevil"."Turn Off Screen" = [];
      "org_kde_powerdevil"."powerProfile" = ["Battery" "Meta+B,Battery" "Meta+B,Switch Power Profile"];
      "plasmashell"."activate application launcher" = ["Meta" "Alt+F1,Meta" "Alt+F1,Activate Application Launcher"];
      "plasmashell"."activate task manager entry 1" = "Meta+1";
      "plasmashell"."activate task manager entry 10" = [];
      "plasmashell"."activate task manager entry 2" = "Meta+2";
      "plasmashell"."activate task manager entry 3" = "Meta+3";
      "plasmashell"."activate task manager entry 4" = "Meta+4";
      "plasmashell"."activate task manager entry 5" = "Meta+5";
      "plasmashell"."activate task manager entry 6" = "Meta+6";
      "plasmashell"."activate task manager entry 7" = "Meta+7";
      "plasmashell"."activate task manager entry 8" = "Meta+8";
      "plasmashell"."activate task manager entry 9" = "Meta+9";
      "plasmashell"."clear-history" = [];
      "plasmashell"."clipboard_action" = "Meta+Ctrl+X";
      "plasmashell"."cycle-panels" = "Meta+Alt+P";
      "plasmashell"."cycleNextAction" = [];
      "plasmashell"."cyclePrevAction" = [];
      "plasmashell"."manage activities" = "Meta+Q";
      "plasmashell"."next activity" = "Meta+A,none,Walk through activities";
      "plasmashell"."previous activity" = "Meta+Shift+A,none,Walk through activities (Reverse)";
      "plasmashell"."repeat_action" = [];
      "plasmashell"."show dashboard" = "Ctrl+F12";
      "plasmashell"."show-barcode" = [];
      "plasmashell"."show-on-mouse-pos" = "Meta+V";
      "plasmashell"."stop current activity" = "Meta+S";
      "plasmashell"."switch to next activity" = [];
      "plasmashell"."switch to previous activity" = [];
      "plasmashell"."toggle do not disturb" = [];
    };
  };
}
