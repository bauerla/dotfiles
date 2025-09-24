#!/bin/zsh

# Config files
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"

# dotfiles
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# shell
alias ls="ls -GFph"
alias copy="tr -d '\n' | pbcopy"

# uuidgen - to lower
if [[ `uname` == Darwin ]] then
	alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'
fi

# start iOS simulator
alias start-simulator="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
