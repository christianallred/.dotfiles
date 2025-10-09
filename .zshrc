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

# TAVA STUFF
# expects HOMEBREW_GITHUB_API_TOKEN, TAVA_AWS_ID, AWS_PROFILE in secrets :) 
# Util func for picking an aws profile
ap () {
  export AWS_PROFILE=$(sed -n "s/\[profile \(.*\)\]/\1/p" ~/.aws/config | fzf) && echo $AWS_PROFILE > ~/.aws_profile
}

awsauth () {
  aws codeartifact login --tool npm --domain tavahealth --namespace @tava --domain-owner $TAVA_AWS_ID --repository tavahealth
  aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $TAVA_AWS_ID.dkr.ecr.us-west-2.amazonaws.com
}

start () {
#  ap
  aws sso login --sso-session CHRISTIAN.ALLRED
  awsauth
}

cli-reset () {
  rm -rf ~/.tava-app
  rm -rf ~/.aws
  mkdir ~/.aws
  tava-cli self-update
  tava-cli init
}

# Added by Windsurf
export PATH="/Users/christianallred/.codeium/windsurf/bin:$PATH"

