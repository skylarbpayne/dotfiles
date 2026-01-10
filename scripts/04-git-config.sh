#!/usr/bin/env bash

# ============================================================================
# Git Configuration
# Set up user identity and preferences
# ============================================================================

configure_git() {
    # Check if already configured
    CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
    CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

    if [[ -n "$CURRENT_NAME" ]] && [[ -n "$CURRENT_EMAIL" ]]; then
        log_info "Git already configured:"
        log_info "  Name:  $CURRENT_NAME"
        log_info "  Email: $CURRENT_EMAIL"
        log_info "Updating Git configuration..."
    else
        log_info "Configuring Git..."
    fi

    git config --global user.name "Skylar Payne"
    git config --global user.email "me@skylarbpayne.com"

    # Additional useful Git settings
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.editor vim
    git config --global push.default simple
    git config --global push.followTags true

    log_info "✓ Git configuration complete:"
    log_info "  Name:  $(git config --global user.name)"
    log_info "  Email: $(git config --global user.email)"
}

# Run Git configuration
configure_git
