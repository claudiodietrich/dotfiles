#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

main() {
	post_install
}

post_install() {
	cd "$HOME/dotfiles"
	sudo dnf install -y git
	git remote set-url origin git@github.com:claudiodietrich/dotfiles.git
	bash scripts/packages_install.sh
}

main "$@"
