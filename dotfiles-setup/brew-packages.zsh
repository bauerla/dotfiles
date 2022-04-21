#!/bin/zsh

# Use user's Brewfile if found in home directory 
brewfile_path=~/dotfiles-setup/Brewfile
[[ -f "$HOME/Brewfile" ]] && brewfile_path=~/Brewfile

export HOMEBREW_BUNDLE_FILE=$brewfile_path # Brewfile location
export HOMEBREW_NO_INSTALL_CLEANUP=1 # manually cleaup after install process
export HOMEBREW_CASK_OPTS="--appdir=~/Applications" # install to user App dir (also in .zprofile)


################################
# Taps
print -P "\n%F{cyan}Adding common Taps and upgrading...%f"

brew tap homebrew/bundle
brew tap homebrew/cask
brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts
#brew tap homebrew/services # installed automatically when first run

# Update
brew update --quiet & brew upgrade


################################
# Common core tools
print -P "\n%F{cyan}Installing common tools (+ Iterm2)...%f"

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
if [[ -f "$HOMEBREW_BUNDLE_FILE" ]]; then
  print -P "\n%F{cyan}Installing from Brewfile located in '$brewfile_path' ...%f"
  brew bundle install --verbose
fi


################################
# Post cleanup and validation
print -P "\n%F{cyan}Doing housekeeping...%f"
brew cleanup & brew doctor

print -P "\n%F{cyan}Done!%f"
