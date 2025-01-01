{
  lib,
  config,
  ...
}: let
  # It may take a restart for the icons to apply.
  # This commented line gets the profile automatically but is inpure.
  #profile = lib.lists.findFirst (value: (lib.strings.hasSuffix "default-default" value)) "" (lib.mapAttrsToList (name: value: name) (builtins.readDir /home/pebble/.var/app/eu.betterbird.Betterbird/.thunderbird));\
  profile = "egxcshns.default-default";
  userjs = lib.strings.concatStrings [".thunderbird/" profile "/user.js"];
  status-icons-prefix = ".local/share/flatpak/app/eu.betterbird.Betterbird/current/active/export/share/icons/hicolor/scalable/status/eu.betterbird.Betterbird-";
in {
  services.flatpak.packages = [
    "eu.betterbird.Betterbird"
  ];

  services.flatpak.overrides = {
    "eu.betterbird.Betterbird".Context.filesystems = [
      "host"
    ];
  };

  home.file."${userjs}".text = ''
    user_pref("mail.startupMinimized", true);
    user_pref("mail.minimizeToTray", true);
  '';

  # Autostart.
  home.file.".config/autostart/eu.betterbird.Betterbird.desktop".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/flatpak/exports/share/applications/eu.betterbird.Betterbird.desktop";

  # System tray icon.
  home.file."${status-icons-prefix}default.svg".text = ''
    <!-- Copyright © Betterbird Project 2021 -->
    <svg xmlns="http://www.w3.org/2000/svg" width="1000" height="1000" fill-rule="evenodd" clip-rule="evenodd" image-rendering="optimizeQuality" shape-rendering="geometricPrecision" text-rendering="geometricPrecision" version="1.0">
      <defs>
        <linearGradient id="a" x1="500" x2="500" y1="0" y2="1000" gradientUnits="userSpaceOnUse">
          <stop offset="0" stop-color="#ffffff"/>
          <stop offset="75%" stop-color="#ffffff"/>
          <stop offset="1" stop-color="#ffffff"/>
        </linearGradient>
      </defs>
      <path fill="url(#a)" d="m 500,39.102 c 39.445,0 78.848,5.022 117.006,14.98 v 0.043 c 96.79,25.367 181.217,81.423 242.166,157.095 0.687,60.95 -7.21,126.19 -23.65,195.725 25.41,-54.64 43.867,-109.28 47.086,-163.92 30.045,44.596 52.45,94.686 65.413,148.51 -17.64,48.589 -42.793,89.665 -73.182,125.505 27.127,-16.997 54.21,-44.639 81.337,-82.926 6.78543,47.36087 6.22112,95.48526 -1.673,142.674 -33.136,33.35 -66.23,54.725 -99.322,72.624 26.912,1.974 55.841,-4.25 86.874,-18.628 -47.3,160.056 -181.045,283.758 -342.905,319.383 -27.17,-28.586 -38.544,-61.335 -62.58,-103.056 -1.33,25.797 12.232,65.972 31.075,108.85 -44.768,6.568 -90.48,6.568 -135.247,-0.042 18.842,-42.88 32.363,-83.011 31.032,-108.808 -24.036,41.72 -35.368,74.47 -62.537,103.013 -161.774,-35.496 -295.648,-159.37 -342.948,-319.34 31.033,14.379 59.962,20.602 86.874,18.628 C 111.726,631.513 78.633,610.138 45.497,576.788 37.602654,529.59964 37.038009,481.4756 43.823,434.115 70.95,472.401 98.077,500.043 125.161,517.04 94.815,481.2 69.62,440.124 51.979,391.536 c 13.005,-53.825 35.41,-103.915 65.413,-148.51 3.22,54.639 21.676,109.279 47.086,163.919 -16.44,-69.534 -24.337,-134.776 -23.65,-195.725 49.79,-61.851 115.288,-110.568 190.36,-140.141 V 71.036 C 384.796,49.876 442.397,39.102 500,39.102 c -167.869,0 -303.975,136.106 -303.975,303.975 0,85.758 35.54,163.233 92.712,218.473 -9.4,-143.274 62.495,-259.335 164.821,-281.01 -35.54,-3.563 -64.898,3.175 -91.381,19.615 14.508,-21.762 38.072,-31.849 54.812,-39.79 -32.75,0.988 -58.975,9.1 -91.725,31.978 141.085,-173.663 460.297,21.675 344.45,138.853 13.392,-47.815 -41.162,-77.045 -99.279,-76.96 -182.676,0.172 -139.84,227.617 20.689,240.665 138.638,11.245 212.85,-130.14 212.85,-251.824 C 803.974,175.208 667.868,39.102 500,39.102 Z M 533.308,273.5 c 35.84,13.477 68.46,3.734 53.094,24.766 -19.315,-5.795 -36.655,-14.594 -53.094,-24.766 z" />
    </svg>
  '';

  # System tray icon when there are unseen emails.
  home.file."${status-icons-prefix}newmail.svg".text = ''
    <!-- Copyright © Betterbird Project 2021 -->
    <svg xmlns="http://www.w3.org/2000/svg" width="1000" height="1000" fill-rule="evenodd" clip-rule="evenodd" image-rendering="optimizeQuality" shape-rendering="geometricPrecision" text-rendering="geometricPrecision" version="1.0">
      <defs>
        <linearGradient id="a" x1="500" x2="500" y1="0" y2="1000" gradientUnits="userSpaceOnUse">
          <stop offset="0" stop-color="white"/>
          <stop offset="75%" stop-color="white"/>
          <stop offset="1" stop-color="white"/>
        </linearGradient>
      </defs>
      <path fill="url(#a)" d="m 500,39.102 c 39.445,0 78.848,5.022 117.006,14.98 v 0.043 c 96.79,25.367 181.217,81.423 242.166,157.095 0.687,60.95 -7.21,126.19 -23.65,195.725 25.41,-54.64 43.867,-109.28 47.086,-163.92 30.045,44.596 52.45,94.686 65.413,148.51 -17.64,48.589 -42.793,89.665 -73.182,125.505 27.127,-16.997 54.21,-44.639 81.337,-82.926 6.78543,47.36087 6.22112,95.48526 -1.673,142.674 -33.136,33.35 -66.23,54.725 -99.322,72.624 26.912,1.974 55.841,-4.25 86.874,-18.628 -47.3,160.056 -181.045,283.758 -342.905,319.383 -27.17,-28.586 -38.544,-61.335 -62.58,-103.056 -1.33,25.797 12.232,65.972 31.075,108.85 -44.768,6.568 -90.48,6.568 -135.247,-0.042 18.842,-42.88 32.363,-83.011 31.032,-108.808 -24.036,41.72 -35.368,74.47 -62.537,103.013 -161.774,-35.496 -295.648,-159.37 -342.948,-319.34 31.033,14.379 59.962,20.602 86.874,18.628 C 111.726,631.513 78.633,610.138 45.497,576.788 37.602654,529.59964 37.038009,481.4756 43.823,434.115 70.95,472.401 98.077,500.043 125.161,517.04 94.815,481.2 69.62,440.124 51.979,391.536 c 13.005,-53.825 35.41,-103.915 65.413,-148.51 3.22,54.639 21.676,109.279 47.086,163.919 -16.44,-69.534 -24.337,-134.776 -23.65,-195.725 49.79,-61.851 115.288,-110.568 190.36,-140.141 V 71.036 C 384.796,49.876 442.397,39.102 500,39.102 c -167.869,0 -303.975,136.106 -303.975,303.975 0,85.758 35.54,163.233 92.712,218.473 -9.4,-143.274 62.495,-259.335 164.821,-281.01 -35.54,-3.563 -64.898,3.175 -91.381,19.615 14.508,-21.762 38.072,-31.849 54.812,-39.79 -32.75,0.988 -58.975,9.1 -91.725,31.978 141.085,-173.663 460.297,21.675 344.45,138.853 13.392,-47.815 -41.162,-77.045 -99.279,-76.96 -182.676,0.172 -139.84,227.617 20.689,240.665 138.638,11.245 212.85,-130.14 212.85,-251.824 C 803.974,175.208 667.868,39.102 500,39.102 Z M 533.308,273.5 c 35.84,13.477 68.46,3.734 53.094,24.766 -19.315,-5.795 -36.655,-14.594 -53.094,-24.766 z" />
      <circle style="fill:#fe5d00" cx="770" cy="770" r="160" />
    </svg>
  '';
}