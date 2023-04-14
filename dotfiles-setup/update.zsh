#!/bin/zsh
#  Update components:
#    Update existing components that needs to be updated manually in some way

################################
# Oh My Zsh
print -P "%F{cyan}\Updating Oh-My-Zsh (OMZ) and its plugins...\n%f"
# update using autoupdate https://github.com/TamCore/autoupdate-oh-my-zsh-plugins#usage
upgrade_oh_my_zsh_all

################################
# NVM
print -P "%F{cyan}\nUpgrading NVM...%f"
nvm upgrade

################################
# Homebrew
print -P "%F{cyan}\nRunning 'brew update' & 'brew upgrade'...%f"
brew update && brew upgrade

################################
# Powerlevel10k
print -P "%F{cyan}\nFetching latest Powerlevel10k...%f"
git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull

print -P "%F{cyan}\n...done! To restart shell run 'exec zsh'%f"

# Restart the zsh session
#exec zsh
