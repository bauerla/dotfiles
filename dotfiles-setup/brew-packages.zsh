#!/bin/zsh

export HOMEBREW_NO_INSTALL_CLEANUP=1 # manually cleanup after install process
export HOMEBREW_CASK_OPTS="--appdir=~/Applications" # install to user App dir (also in .zprofile)


################################
# Taps
print -P "\n%F{cyan}Adding common Taps and upgrading...%f"

# Update
brew update --quiet && brew upgrade


################################
# Common core tools
print -P "\n%F{cyan}Installing common tools (+ Iterm2)...%f"

brew install git wget curl

# GNU utilities (installed with 'g' prefix: gsed, gtar, etc.)
# To use without prefix: export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
brew install coreutils
brew install gnu-sed
brew install gnu-tar
brew install gnu-indent
brew install gnu-which


################################
# Iterm2 - shell integration in 'shell-tools.zsh'
brew install iterm2


################################
# From Brewfile
dotfiles_brewfile=~/dotfiles-setup/Brewfile
user_brewfile=~/Brewfile

print -P "\n%F{cyan}Brewfile installation:%f"

if [[ -f "$user_brewfile" ]]; then
  print -P "  %F{white}1)%f Use your Brewfile    ($user_brewfile)"
  print -P "  %F{white}2)%f Use dotfiles Brewfile ($dotfiles_brewfile)"
  print -P "  %F{white}3)%f Skip"
  while true; do
    read -r "brewfile_choice?Choose [1/2/3]: "
    [[ "$brewfile_choice" =~ ^[123]$ ]] && break
    print -P "%F{yellow}Please enter 1, 2, or 3%f"
  done
else
  print -P "  %F{white}1)%f Use dotfiles Brewfile ($dotfiles_brewfile)"
  print -P "  %F{white}2)%f Skip"
  while true; do
    read -r "brewfile_choice?Choose [1/2]: "
    [[ "$brewfile_choice" =~ ^[12]$ ]] && break
    print -P "%F{yellow}Please enter 1 or 2%f"
  done
  # remap to shared case numbers: 2 (skip) → 3
  [[ "$brewfile_choice" == "2" ]] && brewfile_choice=3
fi

case "$brewfile_choice" in
  1) selected_brewfile="$user_brewfile" ;;
  2) selected_brewfile="$dotfiles_brewfile" ;;
  3)
    print -P "%F{yellow}Skipping Brewfile. To install later run:%f"
    print -P "%F{magenta}  brew bundle install --file <path to Brewfile>%f"
    selected_brewfile=""
    ;;
esac

if [[ -n "$selected_brewfile" ]]; then
  print -P "\n%F{cyan}Installing from '$selected_brewfile' ...%f"
  if ! brew bundle install --file "$selected_brewfile" --verbose; then
    print -P "%F{red}Brewfile installation failed — check output above for details%f"
  fi
fi


################################
# Post cleanup and validation
print -P "\n%F{cyan}Doing some homebrew housekeeping...%f"
brew cleanup && brew doctor

print -P "\n%F{cyan}Done!%f"
