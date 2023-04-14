# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh settings
export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM=$HOME/.oh-my-zsh-custom # according to dotfiles
ZSH_THEME="powerlevel10k/powerlevel10k"

zstyle ':omz:update' mode disabled # disable automatic updates

HIST_STAMPS="dd.mm.yyyy"
DISABLE_UNTRACKED_FILES_DIRTY="true" # speed up repository status check on large repositories 
DISABLE_MAGIC_FUNCTIONS=true # do not touch URLs and text on paste

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# zsh-nvm - has to be before omz plugins init
export NVM_AUTO_USE=true # enable when .nvmrc found in folder
export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true
export NVM_COLORS="bcgmW"
export NVM_DIR="$HOME/.nvm"

# Oh My Zsh plugins
plugins+=(git dotenv yarn zsh-nvm macos zsh-autosuggestions zsh-syntax-highlighting autoupdate)
source $ZSH/oh-my-zsh.sh

### User customizations after this ###

# GNU tools - Uncomment if prefer using without g prefix (replaces BSD tools)
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-indent/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-which/libexec/gnubin:$PATH"

# Homebrew's "sbin"
export PATH="/usr/local/sbin:$PATH"
# Man
export MANPATH="/usr/local/man:$MANPATH"
# curl
export PATH="/usr/local/opt/curl/bin:$PATH"
# Lang
export LANG=en_US.UTF-8
# JDK
export PATH="/usr/local/opt/openjdk/bin:$PATH"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR="code -w"
fi

#setopt NO_CASE_GLOB
#setopt AUTO_CD

# History
HISTSIZE=100000
SAVEHIST=100000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
