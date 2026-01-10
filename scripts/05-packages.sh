#!/usr/bin/env bash

# ============================================================================
# Package Installation
# Install all CLI tools and GUI applications via Homebrew
# ============================================================================

install_packages() {
    # Source package definitions
    source "$DOTFILES_DIR/config/packages.sh"

    # Helper function to check if a GUI app is installed
    is_app_installed() {
        local app_name="$1"

        # Check if Homebrew knows about it
        if brew list --cask "$app_name" &>/dev/null; then
            return 0
        fi

        # Check common app name variations in /Applications
        # Convert cask name to likely app name (e.g., google-chrome -> Google Chrome)
        local app_display_name
        case "$app_name" in
            google-chrome)
                app_display_name="Google Chrome"
                ;;
            visual-studio-code)
                app_display_name="Visual Studio Code"
                ;;
            *)
                # Default: capitalize each word after hyphens
                app_display_name=$(echo "$app_name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
                ;;
        esac

        # Check if app exists in /Applications
        if [[ -d "/Applications/${app_display_name}.app" ]]; then
            return 0
        fi

        return 1
    }

    # Install CLI Core tools
    log_info "Installing CLI core tools..."
    for package in "${CLI_CORE[@]}"; do
        if brew list "$package" &>/dev/null; then
            log_info "  ✓ $package already installed"
        else
            log_info "  Installing $package..."
            brew install "$package" || log_error "  ✗ Failed to install $package"
        fi
    done

    # Install CLI Monitoring tools
    log_info "Installing CLI monitoring/ops tools..."
    for package in "${CLI_MONITORING[@]}"; do
        if brew list "$package" &>/dev/null; then
            log_info "  ✓ $package already installed"
        else
            log_info "  Installing $package..."
            brew install "$package" || log_error "  ✗ Failed to install $package"
        fi
    done

    # Install CLI Development tools
    log_info "Installing CLI development tools..."
    for package in "${CLI_DEV[@]}"; do
        if brew list "$package" &>/dev/null; then
            log_info "  ✓ $package already installed"
        else
            log_info "  Installing $package..."
            brew install "$package" || log_error "  ✗ Failed to install $package"
        fi
    done

    # Install Infrastructure tools
    log_info "Installing infrastructure tools..."
    for package in "${CLI_INFRASTRUCTURE[@]}"; do
        if brew list "$package" &>/dev/null; then
            log_info "  ✓ $package already installed"
        else
            log_info "  Installing $package..."
            brew install "$package" || log_error "  ✗ Failed to install $package"
        fi
    done

    # Install GUI Applications
    log_info "Installing GUI applications..."
    for app in "${GUI_APPS[@]}"; do
        if is_app_installed "$app"; then
            log_info "  ✓ $app already installed"
        else
            log_info "  Installing $app..."

            # Capture output and prevent script exit on error
            INSTALL_FAILED=false
            INSTALL_OUTPUT=$(brew install --cask "$app" 2>&1) || INSTALL_FAILED=true

            if [[ "$INSTALL_FAILED" == "true" ]]; then
                # Check if it's because the app already exists
                if echo "$INSTALL_OUTPUT" | grep -q "It seems there is already an App"; then
                    log_warn "  ⚠ $app appears to be installed manually, skipping Homebrew installation"
                else
                    log_error "  ✗ Failed to install $app"
                    echo "$INSTALL_OUTPUT" | grep -i "error" || echo "$INSTALL_OUTPUT"
                fi
            else
                log_info "  ✓ $app installed successfully"
            fi
        fi
    done

    # Install Claude Code using official curl method
    log_info "Installing Claude Code..."
    if command -v claude &>/dev/null; then
        log_info "  ✓ Claude Code already installed"
        log_info "  Version: $(claude --version 2>/dev/null || echo 'unknown')"
    else
        log_info "  Installing Claude Code via official installer..."

        # Install using official method from GitHub
        # Capture both stdout and stderr, and don't fail on error
        INSTALL_FAILED=false
        INSTALL_OUTPUT=$(curl -fsSL https://raw.githubusercontent.com/anthropics/claude-code/main/install.sh 2>&1 | sh 2>&1) || INSTALL_FAILED=true

        if [[ "$INSTALL_FAILED" == "false" ]]; then
            log_info "  ✓ Claude Code installed successfully"

            # Verify installation
            if command -v claude &>/dev/null; then
                log_info "  Version: $(claude --version 2>/dev/null || echo 'installed')"
            else
                log_warn "  ⚠ Claude Code installed but not found in PATH"
                log_warn "    You may need to restart your terminal"
            fi
        else
            # Check if it's because Claude Code is already installed
            if command -v claude &>/dev/null; then
                log_info "  ✓ Claude Code already available"
                log_info "  Version: $(claude --version 2>/dev/null || echo 'installed')"
            else
                log_warn "  ⚠ Claude Code installer returned an error"
                log_warn "    You can install manually from: https://github.com/anthropics/claude-code"
                # Don't show full output unless there's something useful
                if echo "$INSTALL_OUTPUT" | grep -qi "error\|failed"; then
                    echo "$INSTALL_OUTPUT" | grep -i "error\|failed" | head -3
                fi
            fi
        fi
    fi

    # Cleanup
    log_info "Cleaning up Homebrew..."
    brew cleanup

    log_info "✓ Package installation complete"
}

# Run package installation
install_packages
