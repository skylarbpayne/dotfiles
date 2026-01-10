#!/usr/bin/env bash

# ============================================================================
# SSH Key Generation and GitHub Setup
# Generates ed25519 key and pauses for user to add to GitHub
# ============================================================================

setup_ssh() {
    SSH_KEY="$HOME/.ssh/id_ed25519"
    SSH_EMAIL="me@skylarbpayne.com"

    # Check if key already exists
    if [[ -f "$SSH_KEY" ]]; then
        log_info "SSH key already exists: $SSH_KEY"
        log_info "Public key:"
        echo ""
        cat "$SSH_KEY.pub"
        echo ""

        if ! confirm "Generate a new SSH key (will backup existing)?"; then
            log_info "Using existing SSH key"

            # Test GitHub connection
            SSH_OUTPUT=$(ssh -T git@github.com 2>&1 || true)
            if echo "$SSH_OUTPUT" | grep -q "successfully authenticated\|Hi.*You've successfully authenticated"; then
                log_info "✓ GitHub SSH connection verified"
            else
                log_warn "Could not verify GitHub SSH connection"
                log_warn "Make sure your public key is added to: https://github.com/settings/keys"
            fi
            return 0
        fi

        # Backup existing key
        log_info "Backing up existing SSH key..."
        cp "$SSH_KEY" "$BACKUP_DIR/id_ed25519.backup"
        cp "$SSH_KEY.pub" "$BACKUP_DIR/id_ed25519.pub.backup"
    fi

    # Generate new key
    log_info "Generating new ed25519 SSH key..."
    ssh-keygen -t ed25519 -C "$SSH_EMAIL" -f "$SSH_KEY" -N ""

    log_info "✓ SSH key generated successfully"
    echo ""
    log_info "Public key:"
    echo ""
    cat "$SSH_KEY.pub"
    echo ""

    # Copy to clipboard if possible
    if command -v pbcopy &>/dev/null; then
        cat "$SSH_KEY.pub" | pbcopy
        log_info "✓ Public key copied to clipboard"
    fi

    # Pause for GitHub setup
    echo ""
    log_warn "╔════════════════════════════════════════════════════════════╗"
    log_warn "║  MANUAL STEP REQUIRED: Add SSH Key to GitHub              ║"
    log_warn "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo "  1. Go to: https://github.com/settings/keys"
    echo "  2. Click 'New SSH key'"
    echo "  3. Paste the public key shown above"
    echo "  4. Click 'Add SSH key'"
    echo ""
    log_warn "Press any key after adding the key to GitHub..."
    read -n 1 -s
    echo ""

    # Test GitHub connection
    log_info "Testing GitHub SSH connection..."

    # Capture SSH output (GitHub returns exit code 1 even on success)
    SSH_OUTPUT=$(ssh -T git@github.com 2>&1 || true)

    if echo "$SSH_OUTPUT" | grep -q "successfully authenticated"; then
        log_info "✓ GitHub SSH connection successful!"
    elif echo "$SSH_OUTPUT" | grep -q "Hi.*You've successfully authenticated"; then
        log_info "✓ GitHub SSH connection successful!"
    else
        log_warn "Could not verify GitHub SSH connection"
        log_warn "SSH output: $SSH_OUTPUT"
        log_warn "This may be normal - continuing anyway"
        log_warn "If you have issues later, verify your key is at: https://github.com/settings/keys"
    fi
}

# Run SSH setup
setup_ssh
