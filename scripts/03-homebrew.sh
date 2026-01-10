#!/usr/bin/env bash

# ============================================================================
# Homebrew Installation and Configuration
# macOS package manager for CLI tools and GUI applications
# ============================================================================

install_homebrew() {
    # Check if Homebrew is already installed
    if command -v brew &>/dev/null; then
        log_info "Homebrew already installed at $(which brew)"
        BREW_PREFIX=$(brew --prefix)
        log_info "Homebrew prefix: $BREW_PREFIX"

        # Update Homebrew
        log_info "Updating Homebrew..."
        brew update
        log_info "✓ Homebrew updated"
        return 0
    fi

    log_info "Installing Homebrew..."

    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Determine architecture-specific path
    if [[ $(uname -m) == "arm64" ]]; then
        # Apple Silicon
        BREW_PREFIX="/opt/homebrew"
    else
        # Intel
        BREW_PREFIX="/usr/local"
    fi

    log_info "Homebrew installed at: $BREW_PREFIX"

    # Add Homebrew to PATH for current session
    eval "$($BREW_PREFIX/bin/brew shellenv)"

    # Verify installation
    if ! command -v brew &>/dev/null; then
        log_error "Homebrew installation failed"
        log_error "Please install manually from: https://brew.sh"
        exit 1
    fi

    log_info "✓ Homebrew installed successfully"

    # Update Homebrew
    log_info "Updating Homebrew..."
    brew update
}

# Run Homebrew installation
install_homebrew
