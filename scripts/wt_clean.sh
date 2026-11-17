#!/usr/bin/env bash

# Pick worktrees of the repos in ~/code (TAB to mark several), git worktree remove them,
# and kill any tmux session opened in them. The current tmux session is killed last,
# moving the client to the previous session instead of detaching.

cd "$HOME" || exit 1

list_worktrees() {
    local git_dir main key value
    for git_dir in ~/code/*/.git; do
        [[ -d $git_dir ]] || continue
        main=$(cd "${git_dir%/.git}" && pwd -P)
        git -C "$main" worktree prune
        git -C "$main" worktree list --porcelain | while read -r key value; do
            [[ $key == worktree && $value != "$main" ]] && printf '%s\t%s\t%s\n' "${value/#$HOME/~}" "$value" "$main"
        done
    done
}

sessions_in() {
    tmux list-sessions -F "#{session_path}"$'\t'"#{session_name}" 2>/dev/null |
        awk -F'\t' -v p="$1" '$1 == p || index($1, p "/") == 1 { print $2 }'
}

selected=$(list_worktrees | fzf --multi --reverse --info=inline-right \
    --delimiter='\t' --with-nth=1 --prompt='remove> ' \
    --header='TAB to mark several, ENTER to remove' \
    --preview='git -C {2} status -sb; echo; git -C {2} log --oneline -10')
[[ -z $selected ]] && exit 0

lines=()
while IFS= read -r line; do lines+=("$line"); done <<< "$selected"

current=""
[[ -n $TMUX ]] && current=$(tmux display-message -p '#S')
kill_current=0
failed=0
total=${#lines[@]}
n=0

for line in "${lines[@]}"; do
    IFS=$'\t' read -r label path main <<< "$line"
    n=$((n + 1))
    echo "[$n/$total] $label"

    echo "checking for uncommitted changes..."
    force=()
    if [[ -n $(git -C "$path" status --porcelain 2>/dev/null) ]]; then
        git -C "$path" status -s
        read -rp "$label has uncommitted changes, remove anyway? [y/N] " answer
        if [[ $answer != [yY] ]]; then
            echo "skipped $label"
            failed=1
            continue
        fi
        force=(--force)
    fi

    in_current=0
    sessions=$(sessions_in "$path")
    while IFS= read -r s; do
        [[ -z $s ]] && continue
        if [[ $s == "$current" ]]; then
            in_current=1
        else
            tmux kill-session -t "=$s" && echo "killed tmux session $s"
        fi
    done <<< "$sessions"

    echo "deleting worktree $label..."
    if ! git -C "$main" worktree remove "${force[@]}" "$path"; then
        echo "failed to remove $label"
        failed=1
        continue
    fi
    echo "removed $label"
    ((in_current)) && kill_current=1

    dir=${path%/*}
    while [[ $dir == "$HOME/code/worktrees/"* ]] && rmdir "$dir" 2>/dev/null; do dir=${dir%/*}; done
done

if ((kill_current)); then
    ((failed)) && read -rp "press enter to close " _
    echo "closing current tmux session $current..."
    tmux set-option -t "=$current" detach-on-destroy previous
    tmux kill-session -t "=$current"
fi

exit $failed
