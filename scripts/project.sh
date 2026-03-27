#!/usr/bin/env bash

# selected=$(find ~/code ~/projects ~/work ~/personal -mindepth 1 -maxdepth 1 -type d | fzf)
selected=$(find $1 -mindepth 1 -maxdepth 1 -type d | fzf)

if [[ -z $selected ]]; then
    exit 0
fi

cd $selected
