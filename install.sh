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

echo "linking lazygit/"
ln -n -s ${HOME}/.dotfiles/lazygit ${HOME}/.config/lazygit

echo "linking ghostty/"
ln -n -s ${HOME}/.dotfiles/ghostty ${HOME}/.config/ghostty

echo "linking nvim/"
ln -n -s ${HOME}/.dotfiles/nvim ${HOME}/.config/nvim

echo "Linking .tmux.conf"
ln -n -s ${HOME}/.dotfiles/.tmux.conf ${HOME}/.tmux.conf

echo "linking .kitty.conf"
ln -n -s ${HOME}/.dotfiles/.kitty.conf ${HOME}/.config/kitty/${USER}.conf

# NOTE you need to reference this from ./claude/settings.json we didnt add that here to keep this cleaner
echo "linking claude statusline"
ln -n -s ${HOME}/.dotfiles/claude/statusline-command.py ${HOME}/.claude/statusline-command.py


HAS_KITTY=$(cat ~/.config/kitty/kitty.conf | grep ${USER}.conf)
if [[ -z "$HAS_KITTY" ]]; then
  echo "adding include to kitty.conf"
  echo "include ./${USER}.conf" >> ./.config/kitty/kitty.conf
fi



