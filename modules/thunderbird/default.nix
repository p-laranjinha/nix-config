{
  pkgs,
  funcs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    birdtray
  ];
  opts.autostartScripts.birdtray = ''
    sleep 10
    ${lib.getExe pkgs.birdtray}
  '';

  hm = {
    # Image used in the birdtray tray icon was taken then modified from:
    #  https://github.com/thunderbird/thunderbird-android/blob/c6c033f39793dcd49044320f1cf3ebdb11a2e52b/images/thunderbird/ic_app_logo_monochrome.svg
    home.file.".config/birdtray-config.json".source =
      funcs.mkMutableConfigSymlink ./birdtray-config.json;

    # https://github.com/gyunaev/birdtray/issues/426
    # This fixes birdtray not being able to see if thunderbird is running, because birdtray doesn't
    #  have good wayland support.
    home.packages = with pkgs; [
      (funcs.patchDesktop thunderbird "thunderbird"
        [ "Exec=thunderbird --name thunderbird %U" ]
        [ "Exec=env GDK_BACKEND=x11 thunderbird --name thunderbird %U" ]
      )
    ];

    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
        accountsOrder = [
          "Main"
          "OrangePebble"
        ];
        settings = {
          # Don't show start page.
          "mailnews.start_page.enabled" = false;
          # Don't automatically mark messages as read.
          "mailnews.mark_message_read.auto" = false;
          # Card row count.
          "mail.threadpane.cardsview.rowcount" = 2;
          # Set chat style variant to dark.
          "messenger.options.messagesStyle.variant" = "Dark";
          # Use normal formatting in email text.
          "mail.compose.default_to_paragraph" = false;

          # Set wide layout.
          "main.pane_config.dynamic" = 1;
          # Compact density.
          "mail.uidensity" = 0;
          # Icons without text.
          "toolbar.unifiedtoolbar.buttonstyle" = 2;
          # Set table view.
          "mail.threadpane.listview" = 1;
        };
      };
    };
  };
}
