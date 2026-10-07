#!/bin/zsh

# brew-install.zsh runs as a separate process, so its shellenv eval doesn't carry
# over here — re-run it in this script's own shell if brew isn't on PATH yet
# (e.g. running these scripts back-to-back without reopening the terminal).
if [[ $(command -v brew) == "" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv zsh)"
  else
    print -P "%F{red}brew not found on PATH and not installed at the expected location.%f\nRun %Bbrew-install.zsh%b first, then rerun this script."
    exit 1
  fi
fi

export HOMEBREW_NO_INSTALL_CLEANUP=1 # manually cleanup after install process
export HOMEBREW_CASK_OPTS="--appdir=~/Applications" # install to user App dir (also in .zprofile)


################################
# Taps
print -P "\n%F{cyan}Adding common Taps and upgrading...%f"

# Update
brew update --quiet && brew upgrade


################################
# Common core tools
# git/wget/curl are kept here (not in Brewfile) so everyone gets Homebrew's
# latest versions rather than whatever ships with the current macOS release.
print -P "\n%F{cyan}Installing common tools...%f"

brew install git wget curl


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
  # remap to shared case numbers: 1 (dotfiles Brewfile) → 2, 2 (skip) → 3
  case "$brewfile_choice" in
    1) brewfile_choice=2 ;;
    2) brewfile_choice=3 ;;
  esac
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
