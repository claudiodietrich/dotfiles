#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

readonly CONFIG_DIR="$HOME/dotfiles/.config"
readonly THEMES_DIR="$HOME/dotfiles/themes"

readonly THEMES=(
	"tokyonight-day"
	"tokyonight-moon"
	"tokyonight-night"
	"tokyonight-storm"
)

main() {
	local theme
	theme=$(gum choose "${THEMES[@]}")

	change_fish_theme "$theme"
	change_neovim_theme "$theme"
	change_lualine_theme "$theme"
	change_starship_theme "$theme"
	change_tmux_theme "$theme"
}

validate_theme_file() {
	local theme_file="$1"

	if [[ ! -f "$theme_file" ]]; then
		echo "Error: theme file '$theme_file' not found" >&2
		return 1
	fi
}

change_fish_theme() {
	readonly FISH_CONFIG="$CONFIG_DIR/fish/config.fish"
	local theme="$1"
	local theme_file="$THEMES_DIR/${theme}/fish.theme"

	validate_theme_file "$theme_file" || return 1

	cp "$theme_file" "$CONFIG_DIR/fish/themes/fish.theme"
}

change_neovim_theme() {
	readonly NVIM_OPTIONS="$CONFIG_DIR/nvim/lua/config/options.lua"
	local theme="$1"

	sed -i "s|vim.g.colorscheme = \".*\"|vim.g.colorscheme = \"${theme}\"|" "$NVIM_OPTIONS"
}

change_lualine_theme() {
	readonly NVIM_LUALINE="$CONFIG_DIR/nvim/lua/plugins/lualine.lua"
	local theme="$1"
	local theme_file="$THEMES_DIR/${theme}/lualine"

	validate_theme_file "$theme_file" || return 1

	while IFS='=' read -r key value; do
		sed -i "s|nvim_set_hl(0, \"${key}\", { fg = \"[^\"]*\" })|nvim_set_hl(0, \"${key}\", { fg = ${value} })|" "$NVIM_LUALINE"
	done <"$theme_file"
}

change_starship_theme() {
	readonly STARSHIP_CONFIG="$CONFIG_DIR/starship/starship.toml"
	local theme="$1"
	local theme_file="$THEMES_DIR/${theme}/starship.toml"

	validate_theme_file "$theme_file" || return 1

	local hostname_style
	hostname_style=$(grep '^hostname_style' "$theme_file" | cut -d'"' -f2)

	local directory_style
	directory_style=$(grep '^directory_style' "$theme_file" | cut -d'"' -f2)

	local directory_read_only_style
	directory_read_only_style=$(grep '^directory_read_only_style' "$theme_file" | cut -d'"' -f2)

	local git_branch_style
	git_branch_style=$(grep '^git_branch_style' "$theme_file" | cut -d'"' -f2)

	local git_state_style
	git_state_style=$(grep '^git_state_style' "$theme_file" | cut -d'"' -f2)

	local git_status_style
	git_status_style=$(grep '^git_status_style' "$theme_file" | cut -d'"' -f2)

	local character_success
	character_success=$(grep '^character_success' "$theme_file" | head -1 | cut -d'"' -f2)

	local character_error
	character_error=$(grep '^character_error' "$theme_file" | head -1 | cut -d'"' -f2)

	local character_vimcmd
	character_vimcmd=$(grep '^character_vimcmd' "$theme_file" | head -1 | cut -d'"' -f2)

	local character_vimcmd_visual
	character_vimcmd_visual=$(grep '^character_vimcmd_visual' "$theme_file" | head -1 | cut -d'"' -f2)

	local character_vimcmd_replace
	character_vimcmd_replace=$(grep '^character_vimcmd_replace' "$theme_file" | head -1 | cut -d'"' -f2)

	local character_vimcmd_replace_one
	character_vimcmd_replace_one=$(grep '^character_vimcmd_replace_one' "$theme_file" | head -1 | cut -d'"' -f2)

	sed -i "/^\[hostname\]/,/^\[/ s|^style = '.*'|style = '${hostname_style}'|" "$STARSHIP_CONFIG"
	sed -i "/^\[directory\]/,/^\[/ s|^style = '.*'|style = '${directory_style}'|" "$STARSHIP_CONFIG"
	sed -i "/^\[directory\]/,/^\[/ s|^read_only_style = '.*'|read_only_style = '${directory_read_only_style}'|" "$STARSHIP_CONFIG"
	sed -i "/^\[git_branch\]/,/^\[/ s|^style = '.*'|style = '${git_branch_style}'|" "$STARSHIP_CONFIG"
	sed -i "/^\[git_state\]/,/^\[/ s|^style = '.*'|style = '${git_state_style}'|" "$STARSHIP_CONFIG"
	sed -i "/^\[git_status\]/,/^\[/ s|^style = '.*'|style = '${git_status_style}'|" "$STARSHIP_CONFIG"

	sed -i '/success_symbol/ s/(#[a-fA-F0-9]\{6\})/('"$character_success"')/g' "$STARSHIP_CONFIG"
	sed -i '/error_symbol/ s/(#[a-fA-F0-9]\{6\})/('"$character_error"')/g' "$STARSHIP_CONFIG"
	sed -i '/vimcmd_visual_symbol/ s/(#[a-fA-F0-9]\{6\})/('"$character_vimcmd_visual"')/g' "$STARSHIP_CONFIG"
	sed -i '/vimcmd_replace_one_symbol/ s/(#[a-fA-F0-9]\{6\})/('"$character_vimcmd_replace_one"')/g' "$STARSHIP_CONFIG"
	sed -i '/vimcmd_replace_symbol/ s/(#[a-fA-F0-9]\{6\})/('"$character_vimcmd_replace"')/g' "$STARSHIP_CONFIG"
	sed -i '/vimcmd_symbol/ s/(#[a-fA-F0-9]\{6\})/('"$character_vimcmd"')/g' "$STARSHIP_CONFIG"
}

change_tmux_theme() {
	readonly TMUX_CONFIG="$CONFIG_DIR/tmux/tmux.conf"
	local theme="$1"
	local theme_file="$THEMES_DIR/${theme}/tmux"

	validate_theme_file "$theme_file" || return 1

	local status_bg
	status_bg=$(grep '^status_bg' "$theme_file" | cut -d'"' -f2)

	local status_fg
	status_fg=$(grep '^status_fg' "$theme_file" | cut -d'"' -f2)

	local active_fg
	active_fg=$(grep '^active_fg' "$theme_file" | cut -d'"' -f2)

	sed -i "/status-style/ s|bg='#[^']*'|bg='${status_bg}'|" "$TMUX_CONFIG"
	sed -i "/status-style/ s|fg='#[^']*'|fg='${status_fg}'|" "$TMUX_CONFIG"
	sed -i "/window-status-current-format/ s|fg=#[a-fA-F0-9]\{6\}|fg=${active_fg}|g" "$TMUX_CONFIG"
	sed -i "/status-right/ s|fg=#[a-fA-F0-9]\{6\}|fg=${active_fg}|g" "$TMUX_CONFIG"

	tmux source "$TMUX_CONFIG" 2>/dev/null || true
}

main "$@"
