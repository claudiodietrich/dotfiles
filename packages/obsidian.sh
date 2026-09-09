#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

OBSIDIAN_DIR="/opt/obsidian"
APP_DIR="$OBSIDIAN_DIR/app"
DESKTOP_FILE="$HOME/.local/share/applications/obsidian.desktop"
ICON_PATH="$HOME/.local/share/icons/obsidian.png"
XDG_OPEN="/usr/local/bin/xdg-open"

# Electron runtime libraries missing from the base container image, plus the
# tools this script itself depends on
sudo dnf install -y \
	alsa-lib \
	at-spi2-atk \
	cups-libs \
	curl \
	desktop-file-utils \
	gtk3 \
	jq \
	libXtst \
	libnotify \
	mesa-libGL \
	nss \
	xdg-utils

if [ ! -x "$APP_DIR/AppRun" ]; then
	# desktop-releases.json is the manifest the Obsidian updater itself uses; the
	# GitHub "latest release" endpoint points at mobile-only releases
	version=$(curl -fsSL https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/desktop-releases.json \
		| jq -r .latestVersion)

	download_url="https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/Obsidian-${version}.AppImage"

	tmpdir=$(mktemp -d)
	trap 'rm -rf "$tmpdir"' EXIT

	curl -fsSL -o "$tmpdir/Obsidian.AppImage" "$download_url"
	chmod +x "$tmpdir/Obsidian.AppImage"

	# extracted once: no FUSE dependency and no extraction cost on every launch
	(cd "$tmpdir" && ./Obsidian.AppImage --appimage-extract >/dev/null)

	sudo rm -rf "$APP_DIR"
	sudo mkdir -p "$OBSIDIAN_DIR"
	sudo mv "$tmpdir/squashfs-root" "$APP_DIR"
fi

mkdir -p "$(dirname "$ICON_PATH")" "$(dirname "$DESKTOP_FILE")"

cp "$APP_DIR/usr/share/icons/hicolor/512x512/apps/obsidian.png" "$ICON_PATH"
chmod 644 "$ICON_PATH"

cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Obsidian
Exec=$APP_DIR/AppRun --no-sandbox %U
Icon=$ICON_PATH
Type=Application
Categories=Office;Utility;
MimeType=x-scheme-handler/obsidian;
StartupWMClass=obsidian
EOF

chmod 644 "$DESKTOP_FILE"

update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

xdg-mime default "$(basename "$DESKTOP_FILE")" x-scheme-handler/obsidian

# distrobox sends every xdg-open call to the host; obsidian:// links have to stay
# here instead, resolved by /usr/bin/xdg-open through the container's own
# mimeapps. The symlink is removed first, otherwise the heredoc would be written
# through it into distrobox-host-exec.
sudo rm -f "$XDG_OPEN"
sudo tee "$XDG_OPEN" >/dev/null <<'EOF'
#!/bin/sh

case "$1" in
obsidian://*) exec /usr/bin/xdg-open "$@" ;;
esac

exec /usr/bin/distrobox-host-exec xdg-open "$@"
EOF

sudo chmod 755 "$XDG_OPEN"

# same values distrobox-export itself derives, to name the label and to find the
# entry it writes
host_home="${DISTROBOX_HOST_HOME:-$HOME}"
container_name="${CONTAINER_ID:-$(grep '^name=' /run/.containerenv | cut -d'=' -f2- | tr -d '"')}"
exported_desktop="/run/host${host_home}/.local/share/applications/${container_name}-obsidian.desktop"

# expose the container app in the host application menu, distinguishing it from
# an Obsidian installed on the host itself
distrobox-export --app obsidian --export-label "(${container_name^})"

# distrobox-export rewrites Icon= to a copy in the host home, and skips that copy
# when a file of the same name is already there. Point it back at the container's
# own icon, which the host reads through the bind mounted container home.
sed -i "s|^Icon=.*|Icon=$ICON_PATH|" "$exported_desktop"
