{
  lib,
  config,
  ...
}: let
  cfg = config.personal.displays;
in {
  options.personal.displays = {
    one-1920x1080-screen = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "If only one 1920x1080@60 screen is to be used. For Sunshine.";
    };
  };

  config = {
    # builtins.toJSON also converts lib.mkMerge and lib.mkIf to JSON, so not using it.
    # Although I'm not using lib.mkMerge and lib.mkIf because it is not counted as a string.
    # Using regular if/else doesn't check unused path but its just string so it doesn't matter.
    # But does it still not check the other if/else path if its called by a specialisation?
    home.file.".config/kwinoutputconfig.json".text = ''
      [
          {
              "data": [
                  {
                      "allowSdrSoftwareBrightness": true,
                      "autoRotation": "InTabletMode",
                      "brightness": 1,
                      "colorPowerTradeoff": "PreferAccuracy",
                      "colorProfileSource": "sRGB",
                      "connectorName": "DP-2",
                      "edidHash": "906fbcbfe0add5daca5f1b7377181b74",
                      "edidIdentifier": "BNQ 32647 21573 35 2023 0",
                      "highDynamicRange": false,
                      "iccProfilePath": "",
                      "mode": {${
        if (! cfg.one-1920x1080-screen)
        then ''
          "height": 1440,
          "refreshRate": 165002,
          "width": 2560''
        else ''
          "height": 1080,
          "refreshRate": 60000,
          "width": 1920''
      }
                      },
                      "overscan": 0,
                      "rgbRange": "Automatic",
                      "scale": 1,
                      "sdrBrightness": 200,
                      "sdrGamutWideness": 0,
                      "transform": "Normal",
                      "vrrPolicy": "Automatic",
                      "wideColorGamut": false
                  },
                  {
                      "allowSdrSoftwareBrightness": true,
                      "autoRotation": "InTabletMode",
                      "brightness": 0.41,
                      "colorPowerTradeoff": "PreferAccuracy",
                      "colorProfileSource": "sRGB",
                      "connectorName": "HDMI-A-1",
                      "edidHash": "f80358606f64febb2fe92081b9c37fea",
                      "edidIdentifier": "AOC 9616 9795 36 2018 0",
                      "highDynamicRange": false,
                      "iccProfilePath": "",
                      "mode": {
                          "height": 1080,
                          "refreshRate": 144001,
                          "width": 1920
                      },
                      "overscan": 0,
                      "rgbRange": "Automatic",
                      "scale": 1,
                      "sdrBrightness": 200,
                      "sdrGamutWideness": 0,
                      "transform": "Normal",
                      "vrrPolicy": "Automatic",
                      "wideColorGamut": false
                  }
              ],
              "name": "outputs"
          },
          {
              "data": [
                  {
                      "lidClosed": false,
                      "outputs": [
                          {
                              "enabled": true,
                              "outputIndex": 0,
                              "position": {
                                  "x": 0,
                                  "y": 0
                              },
                              "priority": 0
                          },
                          {
                              "enabled": ${
        if (! cfg.one-1920x1080-screen)
        then "true"
        else "false"
      },
                              "outputIndex": 1,
                              "position": {
                                  "x": 2560,
                                  "y": 360
                              },
                              "priority": 1
                          }
                      ]
                  }
              ],
              "name": "setups"
          }
      ]'';
  };
}
