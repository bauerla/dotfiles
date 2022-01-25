#!/bin/zsh

# Run only if homebrew not installed yet
if [[ $(command -v brew) == "" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # if Apple M1 add brew to PATH instructed by brew
  if [[ `uname -m` == 'arm64' ]]; then
    echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/$(whoami)/.zprofile
    eval $(/opt/homebrew/bin/brew shellenv)
  fi

  # disable analytics
  brew analytics off # disable analytics
fi

BREW_PREFIX=$(brew --prefix)

# update & upgrade existing
brew update
brew upgrade

# App taps & update
brew tap homebrew/cask
brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts
brew tap homebrew/bundle

brew tap teamookla/speedtest

# git and wget if not installed yet
brew install wget git

# iterm2 & its shell integration (sourced in .zshrc)
brew install iterm2
curl -L https://iterm2.com/shell_integration/zsh -o $HOME/.iterm2_shell_integration.zsh


################################
# Oh-My-Zsh & plugins

# oh-my-zsh (keep existing .zshrc file)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

# Zsh plugins (plugins section in .zshrc)
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh-custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh-custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/lukechilds/zsh-nvm ${ZSH_CUSTOM:-$HOME/.oh-my-zsh-custom}/plugins/zsh-nvm


################################
# General

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

# Fonts - change for your liking
brew install font-jetbrains-mono-nerd-font # personal preference for VSCode
#brew install font-fira-code-nerd-font
#brew install font-hack-nerd-font
brew install font-meslo-lg-nerd-font # used by iTerm2

# Screensavers
brew install aerial brooklyn developerexcuses


################################
# From local Brewfile
if [ -f Brewfile ]; then
  brew bundle install --verbose
fi


################################
# App Store apps. Commenting out the 'mas' will not install Apps either
brew install mas

if brew ls --versions mas > /dev/null; then
  mas install 595191960 # CopyClip
  mas install 748212890 # Memory Diag
  #mas install 497799835 # Xcode
fi


################################
# Final check for any issues and cleanup

# set brew external packages autocompletion
chmod -R go-w "${BREW_PREFIX}/share" # make sure no “zsh compinit: insecure directories” errors
rm -f ~/.zcompdump; compinit # force rebuild

brew cleanup & brew doctor
