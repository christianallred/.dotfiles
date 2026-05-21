#!/usr/bin/env bash

# Pick a project/worktree dir and attach (or create) a tmux session for it.
# A fresh session gets four windows: claude, nvim, lazygit, terminal.

if [[ $# -eq 1 ]]; then
    # Resolve relative paths (including ".") to absolute so the session name is sane
    selected=$(cd "$1" 2>/dev/null && pwd)
    if [[ -z $selected ]]; then
        echo "Not a valid directory: $1" >&2
        exit 1
    fi
else
    selected=$(~/.dotfiles/scripts/pick_project.sh) || exit 0
fi

# Session name = picked path with $HOME stripped; tmux disallows ':', '.', '?'
selected_name=$(echo "${selected#$HOME/}" | tr ':.?' '___')
tmux_running=$(pgrep tmux)

setup_windows() {
    local session=$1
    local dir=$2

    tmux rename-window -t "$session:1" claude
    tmux send-keys -t "$session:claude" "claude" C-m

    tmux new-window -t "$session" -n nvim -c "$dir"
    tmux send-keys -t "$session:nvim" "nvim ." C-m

    tmux new-window -t "$session" -n lazygit -c "$dir"
    tmux send-keys -t "$session:lazygit" "lg" C-m

    tmux new-window -t "$session" -n terminal -c "$dir"

    tmux select-window -t "$session:claude"
}

# Not inside tmux and no server running: start fresh and attach
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -ds "$selected_name" -c "$selected"
    setup_windows "$selected_name" "$selected"
    tmux attach -t "$selected_name"
    exit 0
fi

# Session doesn't exist yet, create it detached
if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
    setup_windows "$selected_name" "$selected"
fi

# Switch to it (attach if outside tmux, switch-client if inside)
if [[ -z $TMUX ]]; then
    tmux attach -t "$selected_name"
else
    tmux switch-client -t "$selected_name"
fi
