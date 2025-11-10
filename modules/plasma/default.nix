{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./displays.nix
  ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
  ];
  environment.systemPackages = with pkgs; [
    kdePackages.kdbusaddons # kquitapp6
  ];

  hm = {
    imports = [
      inputs.plasma-manager.homeModules.plasma-manager
    ];

    programs.plasma = {
      enable = true;
      overrideConfig = true;
      workspace = {
        lookAndFeel = "org.kde.breezedark.desktop";
        enableMiddleClickPaste = false;
      };

      # Use the command "plasma-interactiveconsole" and the following website
      #  to find some hard to get config values:
      #  https://develop.kde.org/docs/plasma/scripting/examples/#iterate-all-widgets-and-print-their-config-values
      # I've also included an example script to run with the command to get
      #  config values as ./interactiveconsolesave.js
      panels = [
        {
          location = "bottom";
          height = 44;
          screen = 0;
          lengthMode = "fit";
          alignment = "left";
          # Not using the included systemMonitor option because it sucks.
          widgets = let
            blue = "61,174,233";
            orange = "246,116,0";
            black = "0,0,0";
            # Taken from the systemMonitor option source code.
            toEscapedList = ids:
              if ids != null
              then "[${lib.concatMapStringsSep ", " (x: ''\"${x}\"'') ids}]"
              else null;
          in [
            {
              name = "org.kde.plasma.systemmonitor";
              config = {
                Appearance = {
                  title = "CPU Usage";
                  chartFace = "org.kde.ksysguard.linechart";
                  updateRateLimit = "1000";
                };
                SensorLabels = {
                  "cpu/all/usage" = "Usage";
                  "cpu/all/averageFrequency" = "Average Frequency";
                };
                SensorColors = {
                  "cpu/all/usage" = blue;
                };
                Sensors = {
                  highPrioritySensorIds = toEscapedList ["cpu/all/usage"];
                  lowPrioritySensorIds = toEscapedList ["cpu/all/averageFrequency"];
                };
              };
            }
            {
              name = "org.kde.plasma.systemmonitor";
              config = {
                Appearance = {
                  title = "CPU Temperature";
                  chartFace = "org.kde.ksysguard.linechart";
                  updateRateLimit = "1000";
                };
                SensorLabels = {
                  "cpu/all/maximumTemperature" = "Maximum Temperature";
                  "cpu/all/averageTemperature" = "Average Temperature";
                };
                SensorColors = {
                  "cpu/all/maximumTemperature" = orange;
                };
                Sensors = {
                  highPrioritySensorIds = toEscapedList ["cpu/all/maximumTemperature"];
                  lowPrioritySensorIds = toEscapedList ["cpu/all/averageTemperature"];
                };
                "org.kde.ksysguard.linechart/General" = {
                  rangeAutoY = false;
                  rangeFromY = 40;
                  rangeToY = 95;
                };
              };
            }
            {
              name = "org.kde.plasma.systemmonitor";
              config = {
                Appearance = {
                  title = "GPU Usage";
                  chartFace = "org.kde.ksysguard.linechart";
                  updateRateLimit = "1000";
                };
                SensorLabels = {
                  "gpu/gpu1/usage" = "Usage";
                  "gpu/gpu1/coreFrequency" = "Frequency";
                };
                SensorColors = {
                  "gpu/gpu1/usage" = blue;
                };
                Sensors = {
                  highPrioritySensorIds = toEscapedList ["gpu/gpu1/usage"];
                  lowPrioritySensorIds = toEscapedList ["gpu/gpu1/coreFrequency"];
                };
              };
            }
            {
              name = "org.kde.plasma.systemmonitor";
              config = {
                Appearance = {
                  title = "GPU Temperature";
                  chartFace = "org.kde.ksysguard.linechart";
                  updateRateLimit = "1000";
                };
                SensorLabels = {
                  "gpu/gpu1/temp2" = "Junction Temperature"; # Hotspot
                  "gpu/gpu1/temperature" = "Temperature";
                };
                SensorColors = {
                  "gpu/gpu1/temp2" = orange;
                };
                Sensors = {
                  highPrioritySensorIds = toEscapedList ["gpu/gpu1/temp2"];
                  lowPrioritySensorIds = toEscapedList ["gpu/gpu1/temperature"];
                };
                "org.kde.ksysguard.linechart/General" = {
                  rangeAutoY = false;
                  rangeFromY = 40;
                  rangeToY = 110;
                };
              };
            }
            {
              name = "org.kde.plasma.systemmonitor";
              config = {
                Appearance = {
                  title = "Memory Usage";
                  chartFace = "org.kde.ksysguard.linechart";
                  updateRateLimit = "1000";
                };
                SensorLabels = {
                  "memory/physical/used" = "Used Physical";
                  "memory/swap/used" = "Used Swap";
                };
                SensorColors = {
                  "memory/physical/used" = blue;
                  "memory/swap/used" = orange;
                };
                Sensors = {
                  highPrioritySensorIds = toEscapedList ["memory/physical/used" "memory/swap/used"];
                };
              };
            }
            {
              name = "org.kde.plasma.systemmonitor";
              config = {
                Appearance = {
                  title = "Network Speed";
                  chartFace = "org.kde.ksysguard.linechart";
                  updateRateLimit = "1000";
                };
                SensorLabels = {
                  "network/all/download" = "Download Rate";
                  "network/all/upload" = "Upload Rate";
                };
                SensorColors = {
                  "network/all/download" = blue;
                  "network/all/upload" = orange;
                };
                Sensors = {
                  highPrioritySensorIds = toEscapedList ["network/all/download" "network/all/upload"];
                };
              };
            }
          ];
        }
        {
          location = "bottom";
          height = 44;
          screen = 0;
          lengthMode = "fit";
          alignment = "right";
          widgets = [
            "org.kde.plasma.marginsseparator"
            {
              systemTray.items = {
                showAll = false;
                shown = [
                  "org.kde.plasma.bluetooth"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.volume"
                ];
                # Shown when relevant
                # Broke when I just added 'syncthing'. I assume it's because if
                #  I set 'shown', 'extra', and 'hidden', plasmoids not included
                #  are disabled and it disabled something important.
                extra = [
                  "org.kde.plasma.cameraindicator"
                  "org.kde.plasma.manage-inputmethod"
                  "org.kde.plasma.bluetooth"
                  "org.kde.plasma.keyboardlayout"
                  "org.kde.plasma.devicenotifier"
                  "org.kde.plasma.mediacontroller"
                  "org.kde.plasma.notifications"
                  "org.kde.kscreen"
                  "org.kde.plasma.brightness"
                  "org.kde.plasma.keyboardindicator"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.printmanager"
                  "org.kde.plasma.volume"
                  "martchus.syncthingplasmoid"
                ];
                hidden = [
                  "org.kde.plasma.clipboard"
                  "Syncthing Tray"
                ];
              };
            }
            {
              name = "org.kde.plasma.notes";
              config = {
                General = {
                  color = "translucent";
                };
              };
            }
            {
              digitalClock = {
                calendar.firstDayOfWeek = "sunday";
                time = {
                  format = "24h";
                  showSeconds = "always";
                };
                date.format.custom = "ddd dd/M";
              };
            }
          ];
        }
        # Put the middle panel last so it is on top if I restart plasmashell
        #  after I change values here, so it gets messed up.
        {
          location = "bottom";
          height = 44;
          screen = 0;
          minLength = 800;
          maxLength = 800;
          alignment = "center";
          widgets = [
            {
              kickoff = {
                sortAlphabetically = true;
                icon = "nix-snowflake-white";
                sidebarPosition = "right";
                showActionButtonCaptions = false;
                showButtonsFor = "powerAndSession";
                popupWidth = 791;
              };
            }
            {
              iconTasks = {
                launchers = [
                  # "applications:org.kde.dolphin.desktop"
                  # "applications:org.kde.konsole.desktop"
                ];
                behavior = {
                  grouping.method = "none";
                  middleClickAction = "close";
                };
                appearance = {
                  highlightWindows = true;
                  rows = {
                    multirowView = "lowSpace";
                    maximum = 2;
                  };
                };
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

      # Some config values and changed ones can be obtained by running rc2nix (altough a lot are missing):
      #  nix run github:nix-community/plasma-manager
      # Another way to figure out config values is by running fswatch on ~/.config and changing a setting manually.
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

        # Makes F13 and up work normally and not be the dumb ones like "Tools".
        # The default shortcuts that use the dumb ones stop working, so thats a plus.
        # Found on Keyboard > Keyboard > Key Bindings
        kxkbrc.Layout = {
          ResetOldOptions = true;
          Options = "fkeys:basic_13-24";
        };

        # Limiting the clipboard for safety reasons.
        klipperrc.General = {
          MaxClipItems = 1;
          KeepClipboardContents = false;
          IgnoreImages = false;
        };
      };
      shortcuts = {
        # Some shortcuts and changed ones can be obtained by running rc2nix (altough a lot are missing):
        #  nix run github:nix-community/plasma-manager
        # You can export shortcuts from settings now, so just do that.

        # "<section>"."<key>" = "<shortcut>"
        # "<section>"."<key>" = [ "<shortcut1>" "<shortcut2>" "<others>" ]
        #  in kglobalshortcutssrc turns into
        #   <key>=<shortcut1>\t<shortcut2>\r<others>
        "kwin" = {
          "Window Fullscreen" = "Alt+F11";
        };
      };
    };
  };
}
