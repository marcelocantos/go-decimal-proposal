# Source from zsh or bash, with FORK set to a built checkout of the fork:
#   FORK=$HOME/go-decimal . ./env.sh
: "${FORK:?set FORK to a checkout of https://github.com/marcelocantos/go built with make.bash}"
export GOROOT="$FORK"
export PATH="$GOROOT/bin:$PATH" GOTOOLCHAIN=local GOEXPERIMENT=decimal
