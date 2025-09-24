#!/bin/zsh

# Check if Homebrew installed already
if [[ $(command -v brew) == "" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # disable analytics
  brew analytics off # disable analytics

  print -P "%F{yellow}Important: Remember to close and reopen the terminal to be able to use%f %F{magenta}brew%f"
else
  print -P "%F{cyan}Yay! You have Homebrew installed already!\nRunning update and upgrade... %f"
  # do update and upgrade
  brew update && brew upgrade
fi

# Check for any issues
brew doctor

print -P "%F{cyan}Done!%f"
