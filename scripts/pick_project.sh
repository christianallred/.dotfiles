#!/usr/bin/env bash

# Pick a project from ~/code or a worktree under ~/code/worktrees/<repo>/<branch>.
# With --repos, only list main git checkouts in ~/code (no worktrees).
# Prints the absolute path to stdout on selection; exits non-zero on cancel.

list_projects() {
    find ~/code -mindepth 1 -maxdepth 1 -type d 2>/dev/null
    find ~/code/worktrees -mindepth 2 -maxdepth 2 -type d 2>/dev/null
}

# Worktrees have a .git file, main checkouts a .git directory
list_repos() {
    find ~/code -mindepth 2 -maxdepth 2 -name .git -type d 2>/dev/null | sed 's|/\.git$||'
}

if [[ $1 == --repos ]]; then
    lister=list_repos
else
    lister=list_projects
fi

selected=$($lister | sed "s|^$HOME|~|" | fzf --reverse --info=inline-right)

if [[ -z $selected ]]; then
    exit 1
fi

# Expand ~ back to the absolute path
echo "${selected/#\~/$HOME}"
