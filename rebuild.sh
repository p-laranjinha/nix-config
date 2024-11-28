#!/usr/bin/env bash
# Based on https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5

NIX_CONFIG_DIR=~/nixos/

# Exit immediately if a command exits with a non-zero status.
set -e

# cd to your config dir without affecting shell outside this script
pushd $NIX_CONFIG_DIR

# Early return if no changes were detected.
if git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    exit 0
fi

# Autoformat the nix files
alejandra . &>/dev/null \
  || ( alejandra . ; echo "formatting failed!" && exit 1 )


# Shows your changes
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild switch --flake $NIX_CONFIG_DIR &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current | awk '{print $1 " " $3 " " $4}')

# Commit all changes witih the generation metadata
git commit -am "$current"

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
