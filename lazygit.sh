if (( $+commands[lazygit] )); then
    eval "$(lazygit --generate-shell-completion zsh 2>/dev/null)"
fi
