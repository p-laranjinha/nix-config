#! /usr/bin/env nix-shell 
#! nix-shell -i bash -p bash gum delta

NIX_CONFIG_DIR=/home/pebble/home/nix-config

# cd to your config dir without affecting shell outside this script.
pushd $NIX_CONFIG_DIR &>/dev/null

gum spin --title "Staging all files." -- git add .
if [ $? -eq 0 ]; then
	gum log --time timeonly --level info "Staged all files."
else
	gum log --time timeonly --level error "Failed staging files."
	exit 1
fi

git diff HEAD | delta --paging always
gum log --time timeonly --level info "Finished showing diff."

git commit -m "$(gum input --width 50 --header "Write commit summary:" --placeholder "")" \
           -m "$(gum write --width 80 --header "Write commit description:" --placeholder "")"

if [ $? -eq 0 ]; then
	gum log --time timeonly --level info "Committed changes."
else
	gum log --time timeonly --level error "Failed committing files."
	exit 1
fi

gum spin --title "Rebuilding." -- sudo nixos-rebuild switch --flak $NIX_CONFIG_DIR
if [ $? -eq 0 ]; then
	gum log --time timeonly --level info "Finished rebuilding."
else
	gum log --time timeonly --level error "Failed rebuild."
	exit 1
fi
