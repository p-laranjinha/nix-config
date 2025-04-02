{...}: {
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
          mode = {
            height = 1440;
            refreshRate = 165002;
            width = 2560;
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
          outputs = [
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
          ];
        }
      ];
    }
  ];
}
