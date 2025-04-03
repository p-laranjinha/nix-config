#!/usr/bin/env bash
# Based on https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5

NIX_CONFIG_DIR=~/home/nixos/

# Exit immediately if a command exits with a non-zero status.
set -e

# cd to your config dir without affecting shell outside this script.
pushd $NIX_CONFIG_DIR &>/dev/null

# Update files gotten using fetch which have a comment on the rev or url attribute.
fd .nix --exec update-nix-fetchgit --only-commented

# Autoformat the nix files.
alejandra . &>/dev/null \
  || ( alejandra . ; echo "formatting failed!" && exit 1 )


git submodule update --init --recursive

# Only use git if changes were made.
if git diff --quiet; then
  use_git=false
  echo "No changes detected, not using git."
else
  use_git=true
  # Shows your changes.
  git status

  git add .
fi

echo "NixOS Rebuilding..."

sudo nixos-rebuild switch --flake "${NIX_CONFIG_DIR}?submodules=1"

# Only use git if changes were made.
if $use_git; then
  # Get current generation metadata.
  current=$(nixos-rebuild list-generations | grep current | awk '{print $1 " " $3 " " $4}')

  # Commit all changes witih the generation metadata.
  git commit -am "$current"
  git push
fi

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
