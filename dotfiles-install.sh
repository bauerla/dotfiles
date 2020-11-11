#!/bin/zsh
DIR=${0:a:h}
GIT_DIR=$HOME/.dotfiles
BAK_DIR=$HOME/.dotfiles-backup


dotfiles () { /usr/bin/git --git-dir=$GIT_DIR --work-tree=$HOME "$@"; }

git clone --bare $DOTFILES_REMOTE $GIT_DIR
mkdir -p $HOME/testdest/.dotfiles-backup
dotfiles checkout

if [ $? -eq 0 ]; then
  echo "Checked out dot files...";
else
  echo "Backing up pre-existing dot files...";
  dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} rsync --remove-source-files -avR "$DIR/./{}" $BAK_DIR/
fi;

dotfiles checkout
dotfiles config status.showUntrackedFiles no
