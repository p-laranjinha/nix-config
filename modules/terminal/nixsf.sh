#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash
# shellcheck shell=bash

NIX_CONFIG_DIR=/home/pebble/home/nix-config

# cd to your config dir without affecting shell outside this script.
pushd $NIX_CONFIG_DIR &>/dev/null

./modules/terminal/nixs.sh

gum log --time timeonly --level info "Pushing to origin..."
git push
if [ $? -eq 0 ]; then
    gum log --time timeonly --level info "Pushed to origin."
else
    gum log --time timeonly --level error "Failed to push to origin."
    exit 1
fi
