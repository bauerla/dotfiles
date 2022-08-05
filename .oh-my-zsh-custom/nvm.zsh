nvm-install() {
	if [[ $# -eq 0 ]] ; then
		echo "## Please give node version ##"
	else
  		nvm install $1 --reinstall-packages-from=node --latest-npm
	fi
}
