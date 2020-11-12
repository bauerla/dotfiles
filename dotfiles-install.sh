#!/bin/zsh
dir=${0:a:h}
git_dir=$HOME/.dotfiles
bak_dir=$HOME/.dotfiles-backup

dotfiles () { /usr/bin/git --git-dir=$git_dir --work-tree=$HOME "$@"; }

git clone --bare $DOTFILES_REMOTE $git_dir
mkdir -p $bak_dir
dotfiles checkout

if [ $? -eq 0 ]; then
  echo "Checked out dot files...";
else
  echo "Backing up pre-existing files...";
  dotfiles checkout 2>&1 | egrep "\t+" | awk {'print $1'} | xargs -I{} rsync --remove-source-files -avR "$dir/./{}" $bak_dir/
fi;

dotfiles checkout
dotfiles config status.showUntrackedFiles no
