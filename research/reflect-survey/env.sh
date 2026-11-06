# Source this to use the decimal fork toolchain.
# Set FORK to a checkout of https://github.com/marcelocantos/go built with make.bash.
: "${FORK:?set FORK to the fork checkout, e.g. FORK=$HOME/go-decimal}"
export GOROOT="$FORK"
export PATH="$GOROOT/bin:$PATH"
export GOTOOLCHAIN=local
export GOEXPERIMENT=decimal
