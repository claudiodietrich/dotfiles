#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

main() {
	local DOTFILES_DIR="$HOME/dotfiles"

	install_packages
	apply_dotfiles
}

install_packages() {
	local packages_dir="$DOTFILES_DIR/packages"

	for package in "$packages_dir"/*.sh; do
		if [ -f "$package" ]; then
			bash "$package"
		fi
	done
}

apply_dotfiles() {
	cd "$DOTFILES_DIR"
	stow .
}

main "$@"
