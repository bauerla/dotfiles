# Remove entry from ZSH command history
del_from_hist() {
	if [[ $# -eq 0 ]] ; then
		echo "## Please give a value for delete query ##"
	else
		LC_ALL=C sed -i '' '/'"$1"'/d' $HISTFILE
	fi
}

# make dir and cd to it
mkd () {
  mkdir -p "$@" && cd "$_";
}

# Magick smart resize image (https://www.smashingmagazine.com/2015/06/efficient-image-resizing-with-imagemagick/#bash-shell)
# $1 - input file
# $2 - output width in px
# $3 - export path
smartresize() {
   magick mogrify -path $3 -filter Triangle -define filter:support=2 -thumbnail $2 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $1
}

# ffmpeg mp4 to webm
towebm() {
  filename=$1:t:r
  ffmpeg -i $1 -c:v libvpx-vp9 -pix_fmt yuv420p $filename.webm 
}

# Kill apps using specific port
killproc() {
  lsof -i tcp:"$1" -t | xargs kill -9
  lsof -i tcp:"$1" -t 2>/dev/null >/dev/null || printf "killed processes on port %s\n" "$1"
}

# Test shell loading time
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}