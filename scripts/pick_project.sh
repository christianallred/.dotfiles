#!/usr/bin/env bash

# Pick a project from ~/code or a worktree under ~/code/worktrees/<repo>/<branch>.
# Prints the absolute path to stdout on selection; exits non-zero on cancel.

selected=$({
    find ~/code -mindepth 1 -maxdepth 1 -type d 2>/dev/null
    find ~/code/worktrees -mindepth 2 -maxdepth 2 -type d 2>/dev/null
} | sed "s|^$HOME|~|" | fzf --reverse --info=inline-right)

if [[ -z $selected ]]; then
    exit 1
fi

# Expand ~ back to the absolute path
echo "${selected/#\~/$HOME}"
