#! /usr/bin/env nix-shell 
#! nix-shell -i bash -p bash gum kdePackages.kdbusaddons kdePackages.kde-cli-tools

gum log --time timeonly --level info "Rebuilding..."
sudo nixos-rebuild switch --flake .
if [ $? -eq 0 ]; then
	gum log --time timeonly --level info "Finished rebuilding."
else
	gum log --time timeonly --level error "Failed rebuild."
	exit 1
fi

gum confirm "Restart plasma shell?"
if [ $? -eq 1 ]; then
	exit 1 
fi
gum log --time timeonly --level info "Restarting plasma shell..."
kquitapp6 plasmashell
kstart plasmashell
gum log --time timeonly --level info "Restarted plasma shell."
