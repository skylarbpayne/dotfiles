#!/usr/bin/env bash

# ============================================================================
# Dotfiles Remote Installer
# One-line install: curl -fsSL https://raw.githubusercontent.com/skylarbpayne/dotfiles/master/install.sh | bash
# ============================================================================

set -e
set -u
set -o pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_section() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

main() {
    log_section "Dotfiles Installer"

    # Check if on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This installer is designed for macOS only"
        log_error "Detected OS: $OSTYPE"
        exit 1
    fi

    DOTFILES_DIR="$HOME/.dotfiles"

    # Check if dotfiles already exist
    if [[ -d "$DOTFILES_DIR" ]]; then
        log_warn "Dotfiles directory already exists: $DOTFILES_DIR"
        read -p "Do you want to remove and re-clone? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Backing up existing dotfiles to ~/.dotfiles.old"
            mv "$DOTFILES_DIR" "$HOME/.dotfiles.old"
        else
            log_info "Updating existing dotfiles..."
            cd "$DOTFILES_DIR"
            git pull origin master || {
                log_error "Failed to update dotfiles"
                exit 1
            }
            log_info "Running bootstrap..."
            ./bootstrap.sh
            exit 0
        fi
    fi

    # Check if git is installed
    if ! command -v git &>/dev/null; then
        log_info "Git not found. Installing Xcode Command Line Tools..."
        xcode-select --install
        log_warn "Please complete Xcode installation and run this script again"
        exit 0
    fi

    # Clone repository
    log_info "Cloning dotfiles repository..."
    git clone https://github.com/skylarbpayne/dotfiles.git "$DOTFILES_DIR" || {
        log_error "Failed to clone repository"
        exit 1
    }

    log_info "✓ Repository cloned to $DOTFILES_DIR"

    # Run bootstrap
    log_info "Starting bootstrap process..."
    cd "$DOTFILES_DIR"
    ./bootstrap.sh

    log_section "Installation Complete!"
    log_info "Your system is now configured"
}

main "$@"
