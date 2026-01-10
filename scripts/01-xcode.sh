#!/usr/bin/env bash

# ============================================================================
# Xcode Command Line Tools Installation
# Required for Git, Homebrew, and other development tools
# ============================================================================

install_xcode() {
    # Check if already installed
    if xcode-select -p &>/dev/null; then
        log_info "Xcode Command Line Tools already installed at $(xcode-select -p)"
        return 0
    fi

    log_info "Installing Xcode Command Line Tools..."
    log_warn "A dialog will appear - please click 'Install' and wait for completion"

    # Trigger installation
    xcode-select --install

    # Wait for user to complete installation
    log_warn "Waiting for installation to complete..."
    log_warn "Press any key after the installation finishes..."
    read -n 1 -s

    # Verify installation
    if xcode-select -p &>/dev/null; then
        log_info "✓ Xcode Command Line Tools installed successfully"
    else
        log_error "Xcode Command Line Tools installation failed"
        log_error "Please install manually: xcode-select --install"
        exit 1
    fi
}

# Run installation
install_xcode
