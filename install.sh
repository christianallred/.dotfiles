#!/usr/bin/env bash

if [ "$(pwd)" != "$HOME" ]; then
  echo "Must run from home dir"
  exit 1
fi

echo "Linking .zshrc"
ln -n -s ${HOME}/.dotfiles/.zshrc ${HOME}/.zshrc

echo "linking scripts/"
ln -n -s ${HOME}/.dotfiles/scripts ${HOME}/.scripts

echo "linking lazygit/"
ln -n -s ${HOME}/.dotfiles/lazygit ${HOME}/.config/lazygit

echo "linking nvim/"
ln -n -s ${HOME}/.dotfiles/nvim ${HOME}/.config/nvim

echo "Linking .tmux.conf"
ln -n -s ${HOME}/.dotfiles/.tmux.conf ${HOME}/.tmux.conf

echo "linking .kitty.conf"
ln -n -s ${HOME}/.dotfiles/.kitty.conf ${HOME}/.config/kitty/${USER}.conf


HAS_KITTY=$(cat ~/.config/kitty/kitty.conf | grep ${USER}.conf)
if [[ -z "$HAS_KITTY" ]]; then
  echo "adding include to kitty.conf"
  echo "include ./${USER}.conf" >> ./.config/kitty/kitty.conf
fi



