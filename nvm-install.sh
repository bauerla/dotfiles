#!/bin/zsh

# Note: add default version to be used in your .nvmrc
# default is same as installed version: "lts/*" 

# install nvm and source .zshrc to load nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | PROFILE=/dev/null zsh

source ~/.zshrc

# install latest LTS and npm
nvm install --lts
nvm install-latest-npm
