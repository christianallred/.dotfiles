export EDITOR=nvim

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

# Switch node to the nearest .nvmrc on shell start and every cd; back to default when leaving one
if command -v nvm >/dev/null; then
  autoload -U add-zsh-hook
  load-nvmrc() {
    local nvmrc_path nvmrc_node_version
    nvmrc_path=$(nvm_find_nvmrc)

    if [[ -n $nvmrc_path ]]; then
      nvmrc_node_version=$(nvm version "$(cat "$nvmrc_path")")
      if [[ $nvmrc_node_version == N/A ]]; then
        nvm install
      elif [[ $nvmrc_node_version != "$(nvm version)" ]]; then
        nvm use
      fi
    elif [[ -n $(PWD=$OLDPWD nvm_find_nvmrc) && $(nvm version) != "$(nvm version default)" ]]; then
      nvm use default
    fi
  }
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

# go stuff
export PATH=$PATH:/usr/local/go/bin

if [[ "$(uname)" == "Darwin" ]]; then
  # LibPQ was not happy
  export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi

# this was needed for claude? 
export PATH="$HOME/.local/bin:$PATH"
