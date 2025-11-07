{
  inputs,
  lib,
  this,
  config,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" this.username])
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
    backupFileExtension = "backup";
    overwriteBackup = false;
    extraSpecialArgs = {inherit inputs;};
    # For modules shared by all users;
    sharedModules = [];
  };

  hm = {
    imports = [
      inputs.plasma-manager.homeModules.plasma-manager
    ];

    home = {
      username = this.username;
      homeDirectory = this.homeDirectory;
      stateVersion = this.stateVersion;
    };

    # Nicely reload system units when changing configs.
    systemd.user.startServices = "sd-switch";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Symlinking folders I care about to a sub home folder to have a cleaner home.
    home.file = let
      folders = {
        "desktop" = "Desktop";
        "downloads" = "Downloads";
        "audio" = "Music";
        "images" = "Pictures";
        "videos" = "Videos";
        "documents" = "Documents";
        ".config" = ".config";
        ".local" = ".local";
        ".zen" = ".zen";
      };
    in
      builtins.listToAttrs (builtins.map (target: {
        name = "${lib.removePrefix ((this.homeDirectory) + "/") (this.subHomeDirectory)}/${target}";
        value = {source = config.lib.meta.mkOutOfStoreSymlink "${this.homeDirectory}/${folders.${target}}";};
      }) (builtins.attrNames folders))
      // {
        # Allows for unfree packages to be used by nix-shell
        ".config/nixpkgs/config.nix".text = ''{ allowUnfree = true; }'';
      }
      //
      # Automatically locks the system on startup if the system was started with autologin.
      # Made for use with Sunshine where I can access the system remotely but
      #  still have a password.
      config.lib.meta.mkAutostartScript "lock-if-autologin" ''
        #! /usr/bin/env nix-shell
        #! nix-shell -i bash -p procps
        SDDM_TEST=`pgrep -xa sddm-helper`
        [[ $SDDM_TEST == *"--autologin"* ]] && loginctl lock-session
      '';
  };
}
