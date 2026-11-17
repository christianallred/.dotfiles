#!/usr/bin/env bash

# Pick a repo, create a worktree off its default branch at ~/code/worktrees/<repo>/<branch>,
# run that repo's post-create actions from wt.yml, then open the worktree in a tmux session.

scripts=~/.dotfiles/scripts
config=$scripts/wt.yml

src=$("$scripts/pick_project.sh" --repos) || exit 0
repo=$(basename "$src")

read -rp "worktree name: " branch
[[ -z $branch ]] && exit 0
git check-ref-format --branch "$branch" >/dev/null || exit 1

wt_path="$HOME/code/worktrees/$repo/$branch"

base=$(git -C "$src" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)
base=${base#origin/}
base=${base:-master}

git -C "$src" fetch origin "$base" || exit 1
git -C "$src" worktree add -b "$branch" "$wt_path" "origin/$base" || exit 1

run_actions() {
    [[ -f $config ]] || return 0

    local kind count i action
    kind=$(REPO=$repo yq '.[strenv(REPO)] | type' "$config") || return 1
    case $kind in
        '!!null') return 0 ;;
        '!!seq') ;;
        *) echo "wt: '$repo' in $config must be a list of commands" >&2; return 1 ;;
    esac
    count=$(REPO=$repo yq '.[strenv(REPO)] | length' "$config") || return 1

    export SRC=$src WT=$wt_path REPO=$repo BRANCH=$branch
    local nvm_sh=${NVM_DIR:-$HOME/.nvm}/nvm.sh
    # shellcheck source=/dev/null
    [[ -s $nvm_sh ]] && source "$nvm_sh"

    cd "$wt_path" || return 1
    for ((i = 0; i < count; i++)); do
        action=$(REPO=$repo I=$i yq '.[strenv(REPO)][env(I)]' "$config") || return 1
        echo "wt> $action"
        eval "$action" || { echo "wt: action failed: $action" >&2; return 1; }
    done
}

if ! run_actions; then
    echo "wt: worktree is at $wt_path, skipping tmux" >&2
    exit 1
fi

exec "$scripts/tmux_session.sh" "$wt_path"
