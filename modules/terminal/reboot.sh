#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash
# shellcheck shell=bash

gum confirm "Choose GRUB option to reboot to?"

if [ $? -eq 1 ]; then
    sudo reboot "$@"
fi

# https://askubuntu.com/a/1450176
OPTION_INDEX=$(awk -F\" '/^menuentry / {print $2}' /boot/grub/grub.cfg | cat -n | awk '{print $1-1,$1="",$0}' | gum choose | awk '{print $1}')

sudo grub-reboot "$OPTION_INDEX"
sudo reboot "$@"
