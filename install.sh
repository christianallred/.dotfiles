#!/usr/bin/env bash

if [ "$(pwd)" != "$HOME" ]; then
  echo "Must run from home dir"
  exit 1
fi

if [[ "$(uname)" == "Darwin" ]]; then
  HAS_ZSHRC=$(grep -s "dotfiles/.zshrc" ${HOME}/.zshrc)
  if [[ -z "$HAS_ZSHRC" ]]; then
    echo "adding dotfiles source to .zshrc"
    echo "" >> ${HOME}/.zshrc
    echo "# Dotfiles" >> ${HOME}/.zshrc
    echo "source ${HOME}/.dotfiles/.zshrc" >> ${HOME}/.zshrc
  fi
fi

HAS_BASHRC=$(grep -s "dotfiles/.bashrc" ${HOME}/.bashrc)
if [[ -z "$HAS_BASHRC" ]]; then
  echo "adding dotfiles source to .bashrc"
  echo "" >> ${HOME}/.bashrc
  echo "# Dotfiles" >> ${HOME}/.bashrc
  echo "source ${HOME}/.dotfiles/.bashrc" >> ${HOME}/.bashrc
fi

if [ ! -e "${HOME}/.config/lazygit" ] && [ ! -L "${HOME}/.config/lazygit" ]; then
  echo "linking lazygit/"
  ln -n -s ${HOME}/.dotfiles/lazygit ${HOME}/.config/lazygit
else
  echo "skipping lazygit/ (already exists)"
fi

if [ ! -e "${HOME}/.config/ghostty" ] && [ ! -L "${HOME}/.config/ghostty" ]; then
  echo "linking ghostty/"
  ln -n -s ${HOME}/.dotfiles/ghostty ${HOME}/.config/ghostty
else
  echo "skipping ghostty/ (already exists)"
fi

if [ ! -e "${HOME}/.config/nvim" ] && [ ! -L "${HOME}/.config/nvim" ]; then
  echo "linking nvim/"
  ln -n -s ${HOME}/.dotfiles/nvim ${HOME}/.config/nvim
else
  echo "skipping nvim/ (already exists)"
fi

# NOTE you need to reference this from ./claude/settings.json we didnt add that here to keep this cleaner
if [ ! -e "${HOME}/.claude/statusline-command.py" ] && [ ! -L "${HOME}/.claude/statusline-command.py" ]; then
  echo "linking claude statusline"
  ln -n -s ${HOME}/.dotfiles/claude/statusline-command.py ${HOME}/.claude/statusline-command.py
else
  echo "skipping claude statusline (already exists)"
fi



