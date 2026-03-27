# Load secrets right up front

if [ -f ~/.dotfiles/.zsh_secrets ]; then
  source ~/.dotfiles/.zsh_secrets
fi

# source aliases
if [ -f ~/.dotfiles/.zsh_alias ]; then
  source ~/.dotfiles/.zsh_alias
fi

# Nvm goodness
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# go stuff
export PATH=$PATH:/usr/local/go/bin

if [[ "$(uname)" == "Darwin" ]]; then
  # LibPQ was not happy
  export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi
