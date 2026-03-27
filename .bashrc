# Dotfiles bash config

# source aliases
if [ -f ~/.dotfiles/.zsh_alias ]; then
  source ~/.dotfiles/.zsh_alias
fi

# source secrets
if [ -f ~/.dotfiles/.zsh_secrets ]; then
  source ~/.dotfiles/.zsh_secrets
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Go
export PATH=$PATH:/usr/local/go/bin
