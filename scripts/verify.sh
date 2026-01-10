#!/usr/bin/env bash

# ============================================================================
# Installation Verification Script
# Verify that all components of the bootstrap were installed correctly
# ============================================================================

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[⚠]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }
log_section() { echo -e "\n${BLUE}=== $1 ===${NC}\n"; }

verify_installation() {
    log_section "Verifying Installation"

    local errors=0

    # Check symlinks
    log_section "Checking Symlinks"
    local dotfiles=(".zshrc" ".vimrc" ".tmux.conf" ".gitconfig" ".mackup.cfg" ".bashrc" ".bash_profile")
    for file in "${dotfiles[@]}"; do
        if [[ -L "$HOME/$file" ]]; then
            log_info "$file is symlinked to $(readlink $HOME/$file)"
        else
            log_error "$file is not symlinked"
            ((errors++))
        fi
    done

    # Check Neovim config
    if [[ -L "$HOME/.config/nvim/init.vim" ]]; then
        log_info "init.vim is symlinked to $(readlink $HOME/.config/nvim/init.vim)"
    else
        log_error "init.vim is not symlinked"
        ((errors++))
    fi

    # Check command availability
    log_section "Checking Installed Commands"
    local commands=("brew" "git" "zsh" "tmux" "vim" "nvim" "node" "fzf" "rg" "bat" "eza" "htop" "jq" "gh")
    for cmd in "${commands[@]}"; do
        if command -v "$cmd" &>/dev/null; then
            log_info "$cmd is available at $(which $cmd)"
        else
            log_error "$cmd not found"
            ((errors++))
        fi
    done

    # Check version managers
    log_section "Checking Version Managers"

    # nvm
    if [[ -d "$HOME/.nvm" ]]; then
        log_info "nvm is installed at $HOME/.nvm"
    else
        log_error "nvm not found"
        ((errors++))
    fi

    # uv
    if command -v uv &>/dev/null; then
        log_info "uv is available: $(uv --version 2>/dev/null || echo 'version check failed')"
    else
        log_error "uv not found"
        ((errors++))
    fi

    # Check shell
    log_section "Checking Default Shell"
    if [[ "$SHELL" == *"zsh"* ]]; then
        log_info "Default shell is zsh: $SHELL"
    else
        log_warn "Default shell is not zsh (currently: $SHELL)"
        log_warn "Run: chsh -s $(which zsh)"
    fi

    # Check Oh-My-Zsh
    log_section "Checking Oh-My-Zsh"
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Oh-My-Zsh is installed"

        # Check plugins
        if [[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
            log_info "zsh-autosuggestions is installed"
        else
            log_error "zsh-autosuggestions not found"
            ((errors++))
        fi

        if [[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
            log_info "zsh-syntax-highlighting is installed"
        else
            log_error "zsh-syntax-highlighting not found"
            ((errors++))
        fi
    else
        log_error "Oh-My-Zsh not installed"
        ((errors++))
    fi

    # Check vim-plug
    log_section "Checking Vim Plugins"
    if [[ -f "$HOME/.vim/autoload/plug.vim" ]]; then
        log_info "vim-plug is installed for Vim"
    else
        log_error "vim-plug not found for Vim"
        ((errors++))
    fi

    if [[ -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]]; then
        log_info "vim-plug is installed for Neovim"
    else
        log_error "vim-plug not found for Neovim"
        ((errors++))
    fi

    # Check SSH key
    log_section "Checking SSH Key"
    if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
        log_info "SSH key exists at $HOME/.ssh/id_ed25519"

        # Test GitHub connection
        if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            log_info "GitHub SSH connection successful"
        else
            log_warn "Could not verify GitHub SSH connection"
            log_warn "Add your key at: https://github.com/settings/keys"
        fi
    else
        log_error "SSH key not found"
        ((errors++))
    fi

    # Check GUI applications
    log_section "Checking GUI Applications"
    local apps=("Google Chrome" "Rectangle" "Raycast" "iTerm" "Visual Studio Code" "Obsidian" "Docker")
    for app in "${apps[@]}"; do
        if [[ -d "/Applications/$app.app" ]]; then
            log_info "$app is installed"
        else
            log_warn "$app not found in /Applications"
        fi
    done

    # Summary
    log_section "Verification Summary"
    if [[ $errors -eq 0 ]]; then
        echo ""
        log_info "✓ All checks passed!"
        echo ""
        echo "Your Mac is fully configured and ready to use."
        echo ""
        echo "Next steps:"
        echo "  • Restart your terminal (or run: source ~/.zshrc)"
        echo "  • Grant permissions to Rectangle, Raycast, Docker"
        echo "  • Sign in to Tailscale and connect"
        echo "  • Install Claude Code manually if not available"
        echo ""
    else
        echo ""
        log_error "✗ $errors checks failed"
        echo ""
        echo "Review the errors above and:"
        echo "  • Re-run relevant scripts in ~/.dotfiles/scripts/"
        echo "  • Check ~/.dotfiles/README.md for troubleshooting"
        echo "  • Run bootstrap.sh again (it's safe to re-run)"
        echo ""
    fi

    return $errors
}

# Run verification
verify_installation
exit $?
