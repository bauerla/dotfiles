#!/bin/zsh

# Note: add default version to be used in your .nvmrc
# default is same as installed version: "lts/*" 
VERSION=${1:-lts/*}

# install nvm and source .zshrc to load nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | PROFILE=/dev/null zsh

source ~/.nvm/nvm.sh

# install node and latest npm
nvm install $VERSION
nvm install-latest-npm

nvm alias default $VERSION
