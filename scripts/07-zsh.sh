#!/usr/bin/env bash

# ============================================================================
# Zsh and Oh-My-Zsh Setup
# Install Oh-My-Zsh framework and plugins
# ============================================================================

setup_zsh() {
    # Install Oh-My-Zsh
    ZSH_DIR="$HOME/.oh-my-zsh"

    if [[ -d "$ZSH_DIR" ]]; then
        log_info "Oh-My-Zsh already installed at $ZSH_DIR"
        log_info "Updating Oh-My-Zsh..."
        (cd "$ZSH_DIR" && git pull)
        log_info "✓ Oh-My-Zsh updated"
    else
        log_info "Installing Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_info "✓ Oh-My-Zsh installed successfully"
    fi

    # Install zsh plugins
    log_info "Installing zsh plugins..."

    # zsh-autosuggestions
    AUTOSUGGESTIONS_DIR="$ZSH_DIR/custom/plugins/zsh-autosuggestions"
    if [[ -d "$AUTOSUGGESTIONS_DIR" ]]; then
        log_info "  ✓ zsh-autosuggestions already installed"
    else
        log_info "  Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
        log_info "  ✓ zsh-autosuggestions installed"
    fi

    # zsh-syntax-highlighting
    SYNTAX_HIGHLIGHTING_DIR="$ZSH_DIR/custom/plugins/zsh-syntax-highlighting"
    if [[ -d "$SYNTAX_HIGHLIGHTING_DIR" ]]; then
        log_info "  ✓ zsh-syntax-highlighting already installed"
    else
        log_info "  Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$SYNTAX_HIGHLIGHTING_DIR"
        log_info "  ✓ zsh-syntax-highlighting installed"
    fi

    # Install fzf
    if command -v fzf &>/dev/null; then
        log_info "Setting up fzf integration..."
        if [[ ! -f "$HOME/.fzf.zsh" ]]; then
            $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
            log_info "  ✓ fzf integration configured"
        else
            log_info "  ✓ fzf integration already configured"
        fi
    fi

    # Install zeta theme
    log_info "Installing zeta theme..."
    ZETA_THEME_DIR="$ZSH_DIR/custom/themes"
    ZETA_THEME_FILE="$ZETA_THEME_DIR/zeta.zsh-theme"

    if [[ -f "$ZETA_THEME_FILE" ]]; then
        log_info "  ✓ zeta theme already installed"
    else
        log_info "  Installing zeta theme..."
        mkdir -p "$ZETA_THEME_DIR"

        # Download the theme file from GitHub
        if curl -fsSL https://raw.githubusercontent.com/skylerlee/zeta-zsh-theme/master/zeta.zsh-theme -o "$ZETA_THEME_FILE"; then
            log_info "  ✓ zeta theme installed successfully"
        else
            log_warn "  ⚠ Failed to install zeta theme"
            log_warn "    Falling back to robbyrussell theme in .zshrc"
            log_warn "    You can install manually from: https://github.com/skylerlee/zeta-zsh-theme"
        fi
    fi

    # Change default shell to zsh if not already
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        log_info "Changing default shell to zsh..."

        # Add zsh to allowed shells if needed
        if ! grep -q "$(which zsh)" /etc/shells; then
            log_info "Adding zsh to /etc/shells (requires sudo)..."
            echo "$(which zsh)" | sudo tee -a /etc/shells
        fi

        chsh -s "$(which zsh)"
        log_info "✓ Default shell changed to zsh"
        log_warn "You will need to restart your terminal for this to take effect"
    else
        log_info "✓ Default shell is already zsh"
    fi

    log_info "✓ Zsh setup complete"
}

# Run zsh setup
setup_zsh
