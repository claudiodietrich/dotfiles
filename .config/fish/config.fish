# XDG Base Directory
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# Disable the fish welcome message
set -g fish_greeting

# Enable vi-mode
set -g fish_key_bindings fish_vi_key_bindings

# Set theme
fish_config theme choose fish

# Set global hostmane variable
set -U HOSTNAME (hostname)

# Local user binaries
fish_add_path $HOME/.local/bin

# Go
fish_add_path /usr/local/go/bin
fish_add_path $HOME/.local/go/bin

# Npm
fish_add_path $HOME/.npm-global/bin

# Podman
set -Ux PODMAN_COMPOSE_WARNING_LOGS false

# Tmux
set -gx TMUX_TMPDIR "/tmp/tmux-$HOSTNAME"
mkdir -p "$TMUX_TMPDIR"

# Starship
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
function starship_transient_prompt_func
    starship module character
end
starship init fish | source
enable_transience
