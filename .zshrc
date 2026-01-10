# ============================================================================
# Zsh Configuration
# Minimal setup with Oh-My-Zsh and essential plugins
# ============================================================================

# Path to Oh-My-Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="zeta"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# ============================================================================
# User Configuration
# ============================================================================

# Preferred editor
export EDITOR='nvim'
export VISUAL='nvim'

# ============================================================================
# Path Configuration
# ============================================================================

# Homebrew (Apple Silicon vs Intel)
if [[ -d "/opt/homebrew" ]]; then
    # Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d "/usr/local/Homebrew" ]]; then
    # Intel
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Local bin
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/bin"

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# ============================================================================
# Version Managers
# ============================================================================

# nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load nvm bash_completion

# uv (Python version manager)
if [[ -d "$HOME/.cargo/bin" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# ============================================================================
# Tool Configuration
# ============================================================================

# fzf (fuzzy finder)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf settings
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Use ripgrep for fzf if available
if command -v rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
fi

# bat (better cat)
if command -v bat &> /dev/null; then
    export BAT_THEME="TwoDark"
    alias cat='bat --paging=never'
fi

# eza (better ls)
if command -v eza &> /dev/null; then
    alias ls='eza'
    alias ll='eza -l'
    alias la='eza -la'
    alias tree='eza --tree'
else
    # Fallback to regular ls with colors
    alias ls='ls -GFh'
    alias ll='ls -lh'
    alias la='ls -lAh'
fi

# ============================================================================
# Aliases
# ============================================================================

# Git aliases (in addition to Oh-My-Zsh git plugin)
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tmux
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tn='tmux new -s'

# Vim
alias v='vim'
alias nv='nvim'

# Docker
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'

# System
alias h='history'
alias hg='history | grep'
alias reload='source ~/.zshrc'

# ============================================================================
# Functions
# ============================================================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick find file
ff() {
    find . -type f -iname "*$1*"
}

# Quick find directory
fdir() {
    find . -type d -iname "*$1*"
}

# Extract various archive formats
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ============================================================================
# Additional Configuration
# ============================================================================

# Load local configuration if it exists
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

. "$HOME/.local/bin/env"
