#! /usr/bin/env nix-shell 
#! nix-shell -i bash -p bash gum kdePackages.kdbusaddons kdePackages.kde-cli-tools

gum log --time timeonly --level info "Staging files..."
git add .
if [ $? -eq 0 ]; then
	gum log --time timeonly --level info "Staged files."
else
	gum log --time timeonly --level error "Failed staging files."
	exit 1
fi

gum log --time timeonly --level info "Rebuilding..."
sudo nixos-rebuild switch --flake .
if [ $? -eq 0 ]; then
	gum log --time timeonly --level info "Finished rebuilding."
else
	gum log --time timeonly --level error "Failed rebuild."
	exit 1
fi

echo "Run 'psr' to restart plasma shell."
