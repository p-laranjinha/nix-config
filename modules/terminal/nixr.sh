#! /usr/bin/env nix-shell 
#! nix-shell -i bash -p bash gum fd update-nix-fetchgit alejandra delta

NIX_CONFIG_DIR=/home/pebble/home/nix-config

# cd to your config dir without affecting shell outside this script.
pushd $NIX_CONFIG_DIR &>/dev/null

# Update files gotten using fetchgit which have a comment on the rev or url attribute.
gum log --time timeonly --level info "Updating fetchgit commit references."
fd .nix --exec update-nix-fetchgit --only-commented
if [ $? -eq 0 ]; then
	gum log --time timeonly --level info "Updated fetchgit commit references."
else
	gum log --time timeonly --level warn "Failed to update of fetchgit commit references."
fi

# Autoformat the nix files.
gum log --time timeonly --level info "Formatting files."
alejandra -q .
if [ $? -eq 0 ]; then
	gum log --time timeonly --level info "Finished formatting files."
else
	gum log --time timeonly --level error "Failed formatting files."
	exit 1
fi

gum log --time timeonly --level info "Staging files."
git add .
if [ $? -eq 0 ]; then
	gum log --time timeonly --level info "Staged files."
else
	gum log --time timeonly --level error "Failed staging files."
	exit 1
fi

git diff HEAD --quiet
if [ $? -eq 0 ]; then
	gum log --time timeonly --level error "No changes have been found. Use 'nixs' instead."
	exit 1
fi

git diff HEAD | delta --paging always
gum log --time timeonly --level info "Finished showing diff."

gum log --time timeonly --level info "Committing changes."
git commit -m "$(gum input --width 50 --header "Input commit summary:" --placeholder "")" \
           -m "$(gum write --width 80 --header "Input commit description:" --placeholder "")"

if [ $? -eq 0 ]; then
	gum log --time timeonly --level info "Committed changes."
else
	gum log --time timeonly --level error "Failed committing files."
	exit 1
fi

gum log --time timeonly --level info "Rebuilding."
sudo nixos-rebuild switch --flake .
if [ $? -eq 0 ]; then
	gum log --time timeonly --level info "Finished rebuilding."
else
	gum log --time timeonly --level error "Failed rebuild."
	exit 1
fi

gum log --time timeonly --level info "Pushing to origin."
git push
if [ $? -eq 0 ]; then
	gum log --time timeonly --level info "Pushed to origin."
else
	gum log --time timeonly --level error "Failed to push to origin."
	exit 1
fi
