#!/usr/bin/env bash

# selected=$(find ~/proj ~/projects ~/work ~/personal -mindepth 1 -maxdepth 1 -type d | fzf)
selected=$(find ~/proj -mindepth 1 -maxdepth 1 -type d | fzf)

if [[ -z $selected ]]; then
    exit 0
fi

cd $selected
