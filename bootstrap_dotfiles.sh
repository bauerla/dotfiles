#!/bin/zsh
dotfiles () {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME
}

git clone --bare $DOTFILES_REMOTE $HOME/.dotfiles
mkdir -p .dotfiles-backup
dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out dot files...";
  else
    echo "Backing up pre-existing dot files...";
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi;
dotfiles checkout
dotfiles config status.showUntrackedFiles no