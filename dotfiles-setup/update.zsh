#!/bin/zsh
#  Update components:
#    Update existing components that needs to be updated manually in some way

################################
# Oh My Zsh
print -P "%F{cyan}\Updating Oh-My-Zsh (OMZ) and its plugins...\n%f"
# Uses autoupdate plugin https://github.com/TamCore/autoupdate-oh-my-zsh-plugins#usage
# Updates:
#   - OMZ version
#   - Custom plugins (all git-repositories under $ZSH_CUSTOM folder)
upgrade_oh_my_zsh_all

################################
# NVM
print -P "%F{cyan}\nUpgrading NVM...%f"
nvm upgrade

################################
# Homebrew
print -P "%F{cyan}\nRunning 'brew update' & 'brew upgrade'...%f"
brew update && brew upgrade


print -P "%F{cyan}\n...done! To restart shell run 'exec zsh'%f"
