{
  inputs,
  lib,
  config,
  pkgs,
  funcs,
  ...
}:
{
  imports = [
    inputs.dms-plugin-registry.modules.default
  ];

  config = lib.mkIf config.opts.niri {
    # Hover over the install button in the DMS plugin website to get the names.
    programs.dms-shell.plugins = {
      # Launcher plugins
      calculator.enable = true;
      dankGifSearch.enable = true;
      emojiLauncher.enable = true;
      dankObsidian.enable = true;
      dankStickerSearch.enable = true;
      dankBitwarden.enable = true;

      # Bar plugins
      # dankActions.enable = true;
      amdGpuMonitorFork = {
        enable = true;
        src = pkgs.fetchFromGitHub {
          owner = "skrimix";
          repo = "dms-amd-gpu-monitor";
          rev = "963a9296c80e7381023d682edd13cb157b5c55cd"; # 'alt-syles' branch
          hash = "sha256-VfW95Kvtm/bGtHDEC+EW1bssNQRrVv4BHaNm5YFffss=";
        };
      };
      # easyEffects.enable = true;
      # musicLyrics.enable = true;
    };

    # Dependencies
    environment.systemPackages = with pkgs; [
      # calculator
      libqalculate
      # dankGifSearch
      curl
      kdePackages.qtimageformats
      # amdGpuMonitor
      amdgpu_top
    ];
    hm.programs = {
      # dankBitwarden
      # To finish configuring this, you'll have to:
      #  - Get the api key from the vault at 'Settings > Security > View API Key'.
      #  - 'rbw register'
      rbw = {
        enable = true;
        settings = {
          email = "plcasimiro2000@gmail.com";
          pinentry = pkgs.pinentry-qt; # GUI, looks good enough, and I can unhide the text.
        };
      };
    };

    hm.xdg.configFile = {
      "DankMaterialShell/plugin_settings.json" = {
        source = funcs.mkMutableConfigSymlink ./dms-plugin-settings.json;
        force = true;
      };
    };
  };
}
