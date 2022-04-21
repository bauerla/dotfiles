#!/bin/zsh

# Check if Homebrew installed already
if [[ $(command -v brew) == "" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # if Apple M1 add brew to PATH according to Homebrew and eval
  if [[ `uname -m` == 'arm64' ]]; then
    echo '\n#Homebrew location' >> /Users/$(whoami)/.zprofile
    echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/$(whoami)/.zprofile
  fi

  # disable analytics
  brew analytics off # disable analytics
  
  print -P "%F{yellow}Important: Remember to close and reopen the terminal to be able to `brew`!%f"
else
  print -P "%F{green}Yay! You have Homebrew installed already!%F{cyan}\nRunning update and upgrade... %f"
  # do update and upgrade
  brew update && brew upgrade
fi

# Check for any issues
brew doctor