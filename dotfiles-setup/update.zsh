#!/bin/zsh
#  Update components:
#    Update existing components that needs to be updated manually in some way

# Source user shell env
source "$HOME/.zshrc"

################################
# Oh My Zsh
print -P "%F{cyan}\nUpdating Oh-My-Zsh (OMZ) and its plugins...\n%f"
# Uses autoupdate plugin https://github.com/TamCore/autoupdate-oh-my-zsh-plugins#usage
# Updates:
#   - OMZ version
#   - Custom plugins (all git-repositories under $ZSH_CUSTOM folder)
upgrade_oh_my_zsh_all

# Powerlevel10k
print -P "%F{cyan}\nUpdating Powerlevel10k...%f"
git -C "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" pull

################################
# Homebrew
print -P "%F{cyan}\nRunning brew update & brew upgrade...%f"
brew update --quiet && brew upgrade
print -P "\n%F{cyan}Doing some homebrew housekeeping...%f"
brew cleanup & brew doctor

print -P "%F{cyan}\n...Done! To restart shell run%f %F{magenta}exec zsh%f"
