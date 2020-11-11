#!/bin/zsh

BREW_PREFIX=$(brew --prefix)

# Run only if homebrew not installed
#   Homebrew & related tools
#   iterm2 & its shell integration
#   oh-my-zsh
if [ ! $(which brew) ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

	brew update
	brew upgrade

	brew tap homebrew/cask
	brew tap homebrew/cask-versions
	brew tap homebrew/cask-fonts
	brew tap homebrew/bundle
	brew tap homebrew/services

	brew install curl wget git

	# iterm2 & its shell integration (sourced in .zshrc)
	brew install iterm2

	curl -L https://iterm2.com/shell_integration/zsh \
		-o ~/.iterm2_shell_integration.zsh

	## oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

brew update
brew upgrade

# App taps
brew tap teamookla/speedtest
brew tap romkatv/powerlevel10k

# coreutils
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"
ln -s "${BREW_PREFIX}/bin/greadlink" "${BREW_PREFIX}/bin/readlink"

brew install moreutils
brew install findutils
brew install gnu-sed
brew install gnu-tar gawk gnutls gnupg gnu-indent gnu-getopt

ln -s "${BREW_PREFIX}/bin/gtar" "${BREW_PREFIX}/bin/tar"

# System
brew install htop-osx pidof pstree grep nmap rename ssh-copy-id tree

# Package/version managers
brew install yarn pyenv

# Archive & Git
brew install xz p7zip git rsync

# Images & video
brew install imagemagick ffmpeg

# JSON
brew install jq jo

# Utils
brew install pandoc pv highlight thefuck zsh-syntax-highlighting teamookla/speedtest/speedtest

# Powelevel10k for Zsh
brew install romkatv/powerlevel10k/powerlevel10k


################################
# Casks

# Browsers
brew cask install firefox google-chrome

# Editors
brew cask install visual-studio-code textmate
#brew cask install java android-studio
#brew cask install docker

# Media
brew cask install vlc spotify slack

# Image
brew cask install gimp inkscape skitch

# Utils
brew cask install bitwarden forklift spectacle suspicious-package the-unarchiver virtualbox
brew cask install qlcolorcode qlimagesize qlstephen quicklook-json

# Fonts
brew cask install font-jetbrains-mono font-jetbrains-mono-nerd-font
brew cask install font-fira-code font-fira-code-nerd-font
brew cask install font-meslo-for-powerline font-meslo-lg-nerd-font
brew cask install font-hack-nerd-font

# Screensavers
brew cask install aerial brooklyn developerexcuses

################################
# App Store apps

mas install 595191960 # CopyClip
mas install 748212890 # Memory Diag
#brew mas install 497799835 # Xcode

################################
# Final cleanup & checks
brew cleanup && brew doctor
