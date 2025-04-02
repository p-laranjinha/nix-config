{
  lib,
  config,
  ...
}: let
  one-1920x1080-screen = config.personal.one-1920x1080-screen;
in {
  options.personal.one-1920x1080-screen = {
    sunshine = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "If only one 1920x1080@60 screen is to be used. For Sunshine.";
    };
  };

  config = lib.mkIf false {
    home.file.".config/kwinoutputconfig.json".text = builtins.toJSON [
      {
        name = "outputs";
        data = [
          {
            allowSdrSoftwareBrightness = true;
            autoRotation = "InTabletMode";
            brightness = 1;
            colorPowerTradeoff = "PreferAccuracy";
            colorProfileSource = "sRGB";
            connectorName = "DP-2";
            edidHash = "906fbcbfe0add5daca5f1b7377181b74";
            edidIdentifier = "BNQ 32647 21573 35 2023 0";
            highDynamicRange = false;
            iccProfilePath = "";
            mode = lib.mkMerge [
              (lib.mkIf (!one-1920x1080-screen) {
                height = 1440;
                refreshRate = 165002;
                width = 2560;
              })
              (lib.mkIf one-1920x1080-screen {
                height = 1080;
                refreshRate = 60;
                width = 1920;
              })
            ];
            overscan = 0;
            rgbRange = "Automatic";
            scale = 1;
            sdrBrightness = 200;
            sdrGamutWideness = 0;
            transform = "Normal";
            vrrPolicy = "Automatic";
            wideColorGamut = false;
          }
          {
            allowSdrSoftwareBrightness = true;
            autoRotation = "InTabletMode";
            brightness = 0;
            colorPowerTradeoff = "PreferAccuracy";
            colorProfileSource = "sRGB";
            connectorName = "HDMI-A-1";
            edidHash = "f80358606f64febb2fe92081b9c37fea";
            edidIdentifier = "AOC 9616 9795 36 2018 0";
            highDynamicRange = false;
            iccProfilePath = "";
            mode = {
              height = 1080;
              refreshRate = 144001;
              width = 1920;
            };
            overscan = 0;
            rgbRange = "Automatic";
            scale = 1;
            sdrBrightness = 200;
            sdrGamutWideness = 0;
            transform = "Normal";
            vrrPolicy = "Automatic";
            wideColorGamut = false;
          }
        ];
      }
      {
        name = "setups";
        data = [
          {
            lidClosed = false;
            outputs = lib.mkMerge [
              (
                lib.mkIf (!one-1920x1080-screen)
                [
                  {
                    enabled = true;
                    outputIndex = 0;
                    position = {
                      x = 0;
                      y = 0;
                    };
                    priority = 0;
                  }
                  {
                    enabled = true;
                    outputIndex = 1;
                    position = {
                      x = 2560;
                      y = 360;
                    };
                    priority = 1;
                  }
                ]
              )
              (
                lib.mkIf one-1920x1080-screen
                [
                  {
                    enabled = true;
                    outputIndex = 0;
                    position = {
                      x = 0;
                      y = 0;
                    };
                    priority = 0;
                  }
                ]
              )
            ];
          }
        ];
      }
    ];
  };
}
