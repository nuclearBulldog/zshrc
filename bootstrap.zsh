#!/usr/bin/env zsh

emulate -L zsh
setopt errexit nounset pipefail

readonly SCRIPT_PATH="${0:A}"
readonly REPO_DIR="${SCRIPT_PATH:h}"
readonly TARGET_DIR="${HOME}/zshrc"
readonly ZSHRC_FILE="${HOME}/.zshrc"
readonly ANTIGEN_FILE="${HOME}/antigen.zsh"
readonly ANTIGEN_URL="https://git.io/antigen"
readonly TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"

log() {
    print -P "%F{blue}[INFO]%f $*"
}

success() {
    print -P "%F{green}[OK]%f $*"
}

warn() {
    print -P "%F{yellow}[WARN]%f $*" >&2
}

fail() {
    print -P "%F{red}[ERROR]%f $*" >&2
    return 1
}

backup_file() {
    local file="$1"
    local backup="${file}.backup-${TIMESTAMP}"

    cp -p -- "$file" "$backup"
    success "Backed up ${file} to ${backup}"
}

install_antigen() {
    if [[ -f "$ANTIGEN_FILE" ]]; then
        success "Antigen already exists at ${ANTIGEN_FILE}"
        return
    fi

    if (( ! $+commands[curl] )); then
        fail "curl is required to download Antigen"
    fi

    log "Downloading Antigen"

    if ! curl -fsSL "$ANTIGEN_URL" -o "${ANTIGEN_FILE}.tmp"; then
        rm -f -- "${ANTIGEN_FILE}.tmp"
        fail "Failed to download Antigen"
    fi

    mv -- "${ANTIGEN_FILE}.tmp" "$ANTIGEN_FILE"
    success "Installed Antigen at ${ANTIGEN_FILE}"
}

install_homebrew_packages() {
    local -a packages=(
        bat
        dust
        eza
        fd
        fzf
        lazygit
        neovim
        ripgrep
        zoxide
    )

    if [[ "$OSTYPE" != darwin* ]]; then
        warn "Not running on macOS. Skipping Homebrew package installation."
        return
    fi

    if (( ! $+commands[brew] )); then
        warn "Homebrew is not installed."
        warn "Install it first, then rerun this bootstrap script."
        return
    fi

    local package

    for package in "${packages[@]}"; do
        if brew list --formula "$package" &>/dev/null; then
            success "${package} is already installed"
        else
            log "Installing ${package}"
            brew install "$package"
        fi
    done
}

write_zshrc() {
    if [[ -f "$ZSHRC_FILE" ]]; then
        if grep -Fqx 'source "$HOME/zshrc/init.sh"' "$ZSHRC_FILE"; then
            success "${ZSHRC_FILE} already loads this configuration"
            return
        fi

        backup_file "$ZSHRC_FILE"
    fi

    cat > "$ZSHRC_FILE" <<'EOF'
# Managed by ~/zshrc/bootstrap.zsh
source "$HOME/zshrc/init.sh"
EOF

    success "Created ${ZSHRC_FILE}"
}

check_repository_location() {
    if [[ "$REPO_DIR" == "$TARGET_DIR" ]]; then
        success "Repository is located at ${TARGET_DIR}"
        return
    fi

    fail "Repository must be cloned to ${TARGET_DIR}

Current location:
  ${REPO_DIR}

Expected location:
  ${TARGET_DIR}

Clone it with:
  git clone <repository-url> \"${TARGET_DIR}\""
}

main() {
    log "Bootstrapping Zsh configuration"

    check_repository_location
    install_antigen
    install_homebrew_packages
    write_zshrc

    success "Bootstrap complete"
    print
    print "Start a new shell with:"
    print "  exec zsh"
}

main "$@"
