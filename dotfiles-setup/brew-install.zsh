#!/bin/zsh

# Check if Homebrew installed already
if [[ $(command -v brew) == "" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # if Apple M1 add brew to PATH according to Homebrew and eval
  if [[ `uname -m` == 'arm64' ]]; then
    echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/$(whoami)/.zprofile
    eval $(/opt/homebrew/bin/brew shellenv)
  fi

  # disable analytics
  brew analytics off # disable analytics
else
  print -P "%F{green}Yay! You have Homebrew installed already!%F{cyan}\nRunning update and upgrade... %f"
  # Do update and upgrade
  brew update && brew upgrade
fi

# Check for any issues
brew doctor