# Powerlevel10k instant prompt must remain near the top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew must be available before commands and plugins that depend on it.
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Environment and general shell configuration.
source "$HOME/zshrc/general.sh"
source "$HOME/zshrc/macos.sh"

# Antigen plugin management.
if [[ -r "$HOME/antigen.zsh" ]]; then
    source "$HOME/antigen.zsh"

    antigen use oh-my-zsh

    antigen bundle git
    antigen bundle command-not-found

    antigen bundle <<'EOBUNDLES'
wintermi/zsh-brew
zshzoo/macos
zsh-users/zsh-completions
casonadams/alacritty-shell
raisty/alt-and-select
Sam-programs/zsh-calc
GeoLMg/apt-zsh-plugin
zuxfoucault/colored-man-pages_mod
aemonge/zsh-hookie-projects
chrissicool/zsh-256color
z-shell/zsh-fancy-completions
zdharma-continuum/zui
hlissner/zsh-autopair
jumbojett/zsh-autosuggestions-plugin
unixorn/autoupdate-antigen.zshplugin
TamCore/autoupdate-oh-my-zsh-plugins
drkhsh/zsh-banner
chrissicool/zsh-bash
Jactry/zsh_battery_state
0b10/cheatsheet
joow/macos
zpm-zsh/pretty-time
zsh-users/zsh-syntax-highlighting
EOBUNDLES

    antigen theme romkatv/powerlevel10k
    antigen apply
else
    print -P "%F{yellow}[WARN]%f Antigen not found at $HOME/antigen.zsh"
    print -P "%F{yellow}[WARN]%f Run $HOME/zshrc/bootstrap.zsh"
fi

# Powerlevel10k configuration.
[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# NVM.
export NVM_DIR="$HOME/.nvm"

[[ -s "$NVM_DIR/nvm.sh" ]] &&
    source "$NVM_DIR/nvm.sh"

[[ -s "$NVM_DIR/bash_completion" ]] &&
    source "$NVM_DIR/bash_completion"

# Conda.
if [[ -x /opt/anaconda3/bin/conda ]]; then
    __conda_setup="$('/opt/anaconda3/bin/conda' shell.zsh hook 2>/dev/null)"

    if [[ $? -eq 0 ]]; then
        eval "$__conda_setup"
    elif [[ -r /opt/anaconda3/etc/profile.d/conda.sh ]]; then
        source /opt/anaconda3/etc/profile.d/conda.sh
    else
        path=(/opt/anaconda3/bin $path)
    fi

    unset __conda_setup
fi

# Bun.
export BUN_INSTALL="$HOME/.bun"
path=("$BUN_INSTALL/bin" $path)

[[ -s "$BUN_INSTALL/_bun" ]] &&
    source "$BUN_INSTALL/_bun"

# User-installed executables and OpenJDK.
path=(
    "$HOME/.local/bin"
    /opt/homebrew/opt/openjdk/bin
    $path
)

# Docker completions.
if [[ -d "$HOME/.docker/completions" ]]; then
    fpath=("$HOME/.docker/completions" $fpath)
fi

# Initialise completion once.
autoload -Uz compinit
compinit

# Optional command integrations.
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi

# Interactive aliases and custom completions.
source "$HOME/zshrc/alias.sh"

if (( $+commands[lazygit] )); then
    source "$HOME/zshrc/lazygit.sh"
fi
