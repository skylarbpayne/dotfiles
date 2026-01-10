#!/usr/bin/env bash

# ============================================================================
# Mackup Setup
# Configure Mackup for application settings sync via Google Drive
# ============================================================================

setup_mackup() {
    log_info "Setting up Mackup..."

    # Check if .mackup.cfg is symlinked
    MACKUP_CONFIG="$HOME/.mackup.cfg"

    if [[ ! -L "$MACKUP_CONFIG" ]] && [[ ! -f "$MACKUP_CONFIG" ]]; then
        log_warn "Mackup configuration not found at $MACKUP_CONFIG"
        log_info "Using default configuration with Google Drive backend"
        log_info "Make sure to symlink .mackup.cfg from your dotfiles"
    fi

    # Check if Google Drive is available
    GOOGLE_DRIVE="$HOME/Library/CloudStorage/GoogleDrive-me@skylarbpayne.com/My Drive"

    if [[ ! -d "$GOOGLE_DRIVE" ]]; then
        log_warn ""
        log_warn "╔════════════════════════════════════════════════════════════╗"
        log_warn "║  Google Drive not found                                    ║"
        log_warn "╚════════════════════════════════════════════════════════════╝"
        log_warn ""
        log_warn "Google Drive not found at: $GOOGLE_DRIVE"
        log_warn ""
        log_warn "Please sign in to Google Drive:"
        log_warn "  1. Open System Preferences > Internet Accounts"
        log_warn "  2. Add your Google account"
        log_warn "  3. Enable Google Drive sync"
        log_warn "  4. Wait for initial sync to complete"
        log_warn ""
        log_warn "After signing in, you can run:"
        log_warn "  • mackup backup  - to backup settings"
        log_warn "  • mackup restore - to restore settings"
        log_warn ""
        log_info "Skipping Mackup setup for now"
        return 0
    fi

    log_info "✓ Google Drive found at: $GOOGLE_DRIVE"

    # Check if Mackup backup exists
    MACKUP_BACKUP="$GOOGLE_DRIVE/Mackup"
    if [[ -d "$MACKUP_BACKUP" ]]; then
        log_info "Mackup backup found, restoring..."
        log_warn "This may prompt you to resolve conflicts - follow the prompts"
        mackup restore

        log_info "✓ Mackup restore complete"
    else
        log_info "No existing Mackup backup found"
        log_info "To backup your settings, run: mackup backup"
    fi

    log_info "✓ Mackup setup complete"
}

# Run Mackup setup
setup_mackup
