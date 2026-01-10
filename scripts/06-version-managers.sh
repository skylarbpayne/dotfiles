#!/usr/bin/env bash

# ============================================================================
# Version Managers Installation
# Install nvm (Node.js) and uv (Python)
# ============================================================================

install_version_managers() {
    # Install nvm (Node Version Manager)
    log_info "Installing nvm (Node Version Manager)..."
    NVM_DIR="$HOME/.nvm"

    if [[ -d "$NVM_DIR" ]]; then
        log_info "  ✓ nvm already installed at $NVM_DIR"

        # Check version
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

        if command -v nvm &>/dev/null; then
            log_info "  Current nvm version: $(nvm --version)"
        fi
    else
        log_info "  Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

        # Source nvm for current session
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

        log_info "  ✓ nvm installed successfully"
    fi

    # Install latest LTS Node via nvm
    if command -v nvm &>/dev/null; then
        log_info "Installing Node.js LTS via nvm..."
        nvm install --lts
        nvm use --lts
        log_info "  ✓ Node.js $(node --version) installed"
    else
        log_warn "  Could not load nvm - Node.js LTS not installed via nvm"
        log_warn "  Node.js $(brew --prefix)/bin/node is available via Homebrew"
    fi

    # Install uv (Python version manager)
    log_info "Installing uv (Python version manager)..."

    if command -v uv &>/dev/null; then
        log_info "  ✓ uv already installed"
        log_info "  Current uv version: $(uv --version 2>/dev/null || echo 'unknown')"
    else
        log_info "  Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh

        # Add to PATH for current session
        export PATH="$HOME/.cargo/bin:$PATH"

        if command -v uv &>/dev/null; then
            log_info "  ✓ uv installed successfully"
            log_info "  uv version: $(uv --version)"
        else
            log_warn "  Could not verify uv installation"
            log_warn "  You may need to restart your terminal"
        fi
    fi

    log_info "✓ Version managers installation complete"
}

# Run version managers installation
install_version_managers
