#!/bin/zsh

if [[ $(command -v brew) == "" ]]; then
  # Run only if homebrew not installed
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # if Apple M1 add brew to PATH instructed by brew
  if [[ `uname -m` == 'arm64' ]]; then
    echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/$(whoami)/.zprofile
    eval $(/opt/homebrew/bin/brew shellenv)
  fi

  brew analytics off # disable analytics

  # update & upgrade
  brew update
  brew upgrade

  # App taps & update
  brew tap homebrew/cask
  brew tap homebrew/cask-versions
  brew tap homebrew/cask-fonts
  brew tap homebrew/bundle

  brew tap teamookla/speedtest

  brew install brew-cask-completion
  brew install wget git

  # iterm2 & its shell integration (sourced in .zshrc)
  brew install iterm2

  curl -L https://iterm2.com/shell_integration/zsh \
  -o ~/.iterm2_shell_integration.zsh

  # Zsh plugins (plugins section in .zshrc)
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/lukechilds/zsh-nvm ${ZSH_CUSTOM:-$HOME/custom}/plugins/zsh-nvm

  ## oh-my-zsh (keep existing .zshrc file)
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
else
  # update & upgrade existing
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
brew install romkatv/powerlevel10k/powerlevel10k


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
brew install virtualbox virtualbox-extension-pack
brew install bitwarden forklift spectacle suspicious-package the-unarchiver onyx appcleaner
brew install syntax-highlight

# Fonts
brew install font-jetbrains-mono-nerd-font # VSCode
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
# App Store apps. Commenting out the package will not try to install Apps either
brew install mas

if brew ls --versions mas > /dev/null; then
  mas install 595191960 # CopyClip
  mas install 748212890 # Memory Diag
  #mas install 497799835 # Xcode
fi


################################
# Final check for any issues and cleanup
brew cleanup & brew doctor
