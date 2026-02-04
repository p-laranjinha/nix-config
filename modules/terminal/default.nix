{
  pkgs,
  funcs,
  vars,
  lib,
  ...
}:
{
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [
    zsh
    bash
  ];
  # Prevent the new user dialog in zsh
  system.userActivationScripts.zshrc = "touch .zshrc";
  programs = {
    zsh = {
      shellAliases = {
        lg = "lazygit";

        # Undoes a commit but keeps the changes.
        gitr = "git reset --soft HEAD~1";

        # Restart plasma shell.
        psr = "kquitapp6 plasmashell; kstart plasmashell;";

        # nix-alien commands to run unpatched binaries and find their libraries.
        nixa = "nix-alien-ld --";
        nixafl = "nix-alien-find-libs";

        # Runs a script that rebuild switches this config.
        nixs = toString (funcs.mkMutableConfigSymlink ./nixs.sh);
        # Runs a script that rebuild switches and commits this config.
        nixsf = toString (funcs.mkMutableConfigSymlink ./nixsf.sh);
        nixb = "sudo nixos-rebuild build --flake ${vars.configDirectory}";
        nixl = "nixos-rebuild list-generations";
        nixu = "nix flake update --flake ${vars.configDirectory}";

        # "nix query"
        # Runs nix repl initialized with values from this flake for easier testing and debugging.
        nixq = "nix repl --file ${pkgs.writeText "replinit.nix" ''
          let
            self = builtins.getFlake "config";
          in rec {
            inherit self;
            inherit (self) inputs lib;
            inherit (self.nixosConfigurations) ${vars.hostname};
            inherit (self.nixosConfigurations.${vars.hostname}._module.specialArgs) vars;
            inherit (self.nixosConfigurations.${vars.hostname}._module.args) funcs;
          }
        ''}";
      };
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
      };
      promptInit = ''
        source "${funcs.mkMutableConfigSymlink ./prompt.zsh}"
      '';
      interactiveShellInit = ''
        ZSH_VI_MODE_PLUGIN_FILE="${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
        source "${funcs.mkMutableConfigSymlink ./.zshrc}"
      '';
    };
    bash.enable = true;
    git = {
      enable = true;
      config = {
        init.defaultBranch = "master";
        user.name = "p-laranjinha";
        user.email = "plcasimiro2000@gmail.com";

        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
        delta = {
          navigate = "true"; # use n and N to move between diff sections
          dark = "true";
          line-numbers = "true";
          hyperlinks = "true";
        };
        merge.conflictStyle = "zdiff3";
      };
      # Git extension for versioning large files (Git Large File Storage).
      lfs.enable = true;
    };

    tmux.enable = true;

    # Tool to locate the nixpkgs package providing a certain file. Used by comma.
    nix-index.enable = true;
  };

  hm = {
    programs = {
      gh.enable = true;

      # Throws an error when not set with home manager.
      zoxide.enable = true;
      # Required for zoxide to set the 'z' and 'zi' commands when set with home manager.
      zsh.enable = true;
    };

    home.file = {
      ".config/ghostty/config".source = funcs.mkMutableConfigSymlink ./ghostty/config;
      ".config/tmux/tmux.conf".source = funcs.mkMutableConfigSymlink ./tmux/tmux.conf;
      ".config/tmux/plugins/tpm".source = funcs.mkOutOfStoreSymlink (
        pkgs.fetchFromGitHub {
          owner = "tmux-plugins";
          repo = "tpm";
          rev = "master";
          hash = "sha256-hW8mfwB8F9ZkTQ72WQp/1fy8KL1IIYMZBtZYIwZdMQc=";
        }
      );
      ".config/tmux/plugins/tmux-which-key/config.yaml".source =
        funcs.mkMutableConfigSymlink ./tmux/which-key.yaml;
      ".config/tmux/scripts".source = funcs.mkMutableConfigSymlink ./tmux/scripts;
    };

  };

  environment.systemPackages = with pkgs; [
    # Terminals.
    ghostty
    wezterm

    # Tool to remove large files from git history. Call with "bfg".
    bfg-repo-cleaner

    # TUI for git.
    lazygit

    # App to give quick examples of how to use most commands.
    tldr

    # CLI tool to run programs without installing them on Nix. Functionally an easier to use nix-shell. Requires nix-index.
    comma

    # Nix formatter.
    alejandra
    nixfmt
    # Formatter multiplexer
    treefmt
    # Nix package version diff tool.
    nvd

    # Library for notifications.
    libnotify

    # find replacement, used to update fetchgit references together with update-nix-fetchgit in nixr.
    fd
    update-nix-fetchgit

    # Library with a bunch of terminal inputs and outputs.
    gum

    # Tool to see file changes in real time.
    fswatch

    # Syntax highlighting pager.
    delta

    # 'cat' replacement with syntax highlighting.
    bat

    # Calculator used by my zsh theme to calculate run times.
    bc

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
