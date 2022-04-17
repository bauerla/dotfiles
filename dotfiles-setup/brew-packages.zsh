#!/bin/zsh

export HOMEBREW_NO_INSTALL_CLEANUP=1 # manually cleaup after install process
export HOMEBREW_CASK_OPTS="--appdir=~/Applications" # install to user App dir (also in .zprofile)

################################
# Taps
brew tap homebrew/bundle
brew tap homebrew/cask
brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts
#brew tap homebrew/services # installed automatically when first run

# Update
brew update --quiet & brew upgrade


################################
# Common core tools
brew install git wget curl


# GNU utilities
brew install coreutils
brew install gnu-sed
brew install gnu-tar
brew install gnu-indent
brew install gnu-which


################################
# Iterm2 - shell integration in 'shell-tools.zsh'
brew install iterm2


################################
# From local Brewfile
if [ -f $HOME/Brewfile ]; then
  echo "--------------- Local Brewfile found. Installing... -----------------"
  brew bundle install --verbose
fi


################################
# Post cleanup and validation
brew cleanup & brew doctor
