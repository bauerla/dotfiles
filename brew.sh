#!/bin/zsh

if [[ $(command -v brew) == "" ]]; then
  # Run only if homebrew not installed
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  brew analytics off # disable analytics

  # App taps & update
  brew tap homebrew/cask
  brew tap homebrew/cask-versions
  brew tap homebrew/cask-fonts
  brew tap homebrew/bundle
  
  brew tap teamookla/speedtest
  
  brew update
  brew upgrade

  brew install brew-cask-completion
  brew install wget git

  # iterm2 & its shell integration (sourced in .zshrc)
  brew install iterm2

  curl -L https://iterm2.com/shell_integration/zsh \
  -o ~/.iterm2_shell_integration.zsh

  ## oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
else
  brew update
  brew upgrade
fi

BREW_PREFIX=$(brew --prefix)

# coreutils
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"
ln -s "${BREW_PREFIX}/bin/greadlink" "${BREW_PREFIX}/bin/readlink"

brew install findutils
brew install gnu-sed
brew install gnu-tar gawk gnutls gnupg gnu-indent

ln -s "${BREW_PREFIX}/bin/gtar" "${BREW_PREFIX}/bin/tar"

# System
brew install htop pidof pstree rename tree

# Package/version managers
brew install yarn pyenv

# Archive
brew install p7zip rsync

# Images & video
brew install imagemagick ffmpeg

# JSON
brew install jq jo

# Utils
brew install pandoc pv thefuck speedtest

# Zsh & Powelevel10k
brew install zsh-syntax-highlighting romkatv/powerlevel10k/powerlevel10k


################################
# Casks

# Browsers
brew install firefox google-chrome

# Editors
brew install visual-studio-code textmate
#brew install java android-studio
#brew install docker

# Media
brew install vlc spotify slack

# Image
brew install gimp inkscape skitch

# Utils
brew install bitwarden forklift spectacle suspicious-package the-unarchiver virtualbox
brew install syntax-highlight

# Fonts
brew instal font-jetbrains-mono-nerd-font # VSCode
brew install font-meslo-lg-nerd-font # iTerm2
#brew install font-fira-code-nerd-font
#brew install font-hack-nerd-font

# Screensavers
brew install aerial brooklyn developerexcuses

################################
# From local Brewfile
if [ -f Brewfile ]; then
	brew bundle install --verbose
fi

################################
# App Store apps
brew install mas

mas install 595191960 # CopyClip
mas install 748212890 # Memory Diag
#mas install 497799835 # Xcode


################################
# Final cleanup & checks
brew cleanup && brew doctor
