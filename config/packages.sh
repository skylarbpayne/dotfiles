#!/usr/bin/env bash

# ============================================================================
# Package Definitions
# Centralized list of all packages to install via Homebrew
# ============================================================================

# CLI Tools - Core
CLI_CORE=(
    "zsh"
    "tmux"
    "vim"
    "neovim"
    "git"
    "gh"  # GitHub CLI
)

# CLI Tools - Monitoring/Ops
CLI_MONITORING=(
    "htop"
    "ncdu"
    "jq"
    "yq"
    "fzf"
    "ripgrep"
    "bat"
    "eza"
    "fd"
    "tldr"
)

# CLI Tools - Development
CLI_DEV=(
    "mackup"
    "node"  # Required for coc.nvim
)

# Infrastructure
CLI_INFRASTRUCTURE=(
    "tailscale"
)

# Zsh Plugins (will be cloned from GitHub)
ZSH_PLUGINS=(
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
)

# GUI Applications (Casks)
GUI_APPS=(
    "google-chrome"
    "rectangle"
    "raycast"
    "iterm2"
    "visual-studio-code"
    "obsidian"
    "docker"
)

# Export arrays for use in other scripts
export CLI_CORE
export CLI_MONITORING
export CLI_DEV
export CLI_INFRASTRUCTURE
export ZSH_PLUGINS
export GUI_APPS
