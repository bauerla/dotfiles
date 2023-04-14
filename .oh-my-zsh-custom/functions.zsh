# Remove entry from ZSH command history
del_from_hist() {
	if [[ $# -eq 0 ]] ; then
		echo "## Please give a value for delete query ##"
	else
		LC_ALL=C sed -i '' '/'"$1"'/d' $HISTFILE
	fi
}

mkd () {
  mkdir -p "$@" && cd "$_";
}

# Magick smart resize image
smartresize() {
   magick mogrify -path $3 -filter Triangle -define filter:support=2 -thumbnail $2 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $1
}

# Kill apps using specific port
killproc() {
  lsof -i tcp:"$1" -t | xargs kill -9
  lsof -i tcp:"$1" -t 2>/dev/null >/dev/null || printf "killed processes on port %s\n" "$1"
}

# Yarn needs a little force sometimes
yarn-rynkytys() {
	yarn; while [ $? -ne 0 ]; do yarn; done;
}

# Test shell loading time
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}