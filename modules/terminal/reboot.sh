#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash
# shellcheck shell=bash

gum confirm "Choose GRUB option to reboot to?"
EXIT_CODE=$?

if [ $EXIT_CODE -eq 1 ]; then
    sudo reboot "$@"
fi
if [ $EXIT_CODE -ne 0 ]; then
    exit $EXIT_CODE
fi

# https://askubuntu.com/a/1450176
OPTION=$(awk -F\" '/^menuentry / {print $2}' /boot/grub/grub.cfg | cat -n | awk '{print $1-1,$1="",$0}' | gum choose)
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
    exit $EXIT_CODE
fi
OPTION_INDEX=$(echo $OPTION | awk '{print $1}')

sudo grub-reboot "$OPTION_INDEX"
sudo reboot "$@"
