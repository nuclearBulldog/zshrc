if [[ "$OSTYPE" == darwin* ]]; then
    export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
fi
