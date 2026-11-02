alias cls="clear"

if (( $+commands[nvim] )); then
    alias v="nvim"
    alias vim="nvim"
    alias sv="sudoedit"
fi

if (( $+commands[eza] )); then
    alias ls="eza"
    alias ll="eza -la --icons --git"
    alias tree="eza --tree --icons"
fi

if (( $+commands[bat] )); then
    alias cat="bat"
fi

if (( $+commands[rg] )); then
    alias grep="rg"
fi

if (( $+commands[dust] )); then
    alias show="dust"
fi

if (( $+commands[networkQuality] )); then
    alias netCh="networkQuality -v"
fi

alias files_show='defaults write com.apple.finder AppleShowAllFiles YES && killall Finder'
alias files_hide='defaults write com.apple.finder AppleShowAllFiles NO && killall Finder'
