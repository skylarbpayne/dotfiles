#!/usr/bin/env bash

# ============================================================================
# macOS Bootstrap Script
# Automated setup for Mac mini homelab
# ============================================================================

# Strict error handling
set -e
set -u
set -o pipefail

# ============================================================================
# Global Variables
# ============================================================================

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# Utility Functions
# ============================================================================

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

# Prompt for confirmation
confirm() {
    local prompt="$1"
    read -p "$prompt (y/n) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This script is designed for macOS only"
        log_error "Detected OS: $OSTYPE"
        exit 1
    fi
    log_info "Running on macOS"
}

# Error handler
error_handler() {
    log_error "Script failed on line $1"
    log_error "Backup of original files available at: $BACKUP_DIR"
    log_error "You can restore by running: cp -r $BACKUP_DIR/* ~/"
    exit 1
}

# Set up error trap
trap 'error_handler $LINENO' ERR

# ============================================================================
# Main Function
# ============================================================================

main() {
    log_section "macOS Bootstrap - Starting Setup"

    # Check prerequisites
    check_macos

    # Display information
    log_info "This script will:"
    echo "  • Install Xcode Command Line Tools"
    echo "  • Generate SSH key and pause for GitHub setup"
    echo "  • Install Homebrew package manager"
    echo "  • Configure Git with your identity"
    echo "  • Install CLI tools (vim, tmux, zsh, etc.)"
    echo "  • Install GUI applications (Chrome, VS Code, etc.)"
    echo "  • Install Claude Code CLI"
    echo "  • Install version managers (nvm, uv)"
    echo "  • Set up Oh-My-Zsh with plugins"
    echo "  • Symlink dotfiles (with backup)"
    echo "  • Set up vim-plug and coc.nvim"
    echo "  • Configure macOS system defaults"
    echo "  • Set up Mackup for settings sync"
    echo ""
    log_info "Backup directory: $BACKUP_DIR"
    echo ""
    log_info "Starting in 3 seconds... (Ctrl+C to cancel)"
    sleep 3

    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    log_info "Backup directory created"

    # Execute installation steps in order
    log_section "Step 1/11: Xcode Command Line Tools"
    source "$SCRIPTS_DIR/01-xcode.sh"

    log_section "Step 2/11: SSH Key Generation"
    source "$SCRIPTS_DIR/02-ssh.sh"

    log_section "Step 3/11: Homebrew Installation"
    source "$SCRIPTS_DIR/03-homebrew.sh"

    log_section "Step 4/11: Git Configuration"
    source "$SCRIPTS_DIR/04-git-config.sh"

    log_section "Step 5/11: Package Installation"
    source "$SCRIPTS_DIR/05-packages.sh"

    log_section "Step 6/11: Version Managers (nvm, uv)"
    source "$SCRIPTS_DIR/06-version-managers.sh"

    log_section "Step 7/11: Zsh and Oh-My-Zsh Setup"
    source "$SCRIPTS_DIR/07-zsh.sh"

    log_section "Step 8/11: Dotfiles Symlinking"
    source "$SCRIPTS_DIR/08-symlinks.sh"

    log_section "Step 9/11: Vim Plugin Setup"
    source "$SCRIPTS_DIR/09-vim-setup.sh"

    log_section "Step 10/11: macOS Defaults Configuration"
    source "$SCRIPTS_DIR/10-macos-defaults.sh"

    log_section "Step 11/11: Mackup Setup"
    source "$SCRIPTS_DIR/11-mackup.sh"

    # Final messages
    log_section "Bootstrap Complete!"
    log_info "✓ All installations completed successfully"
    echo ""
    log_info "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Verify installation: ~/.dotfiles/scripts/verify.sh"
    echo "  3. Grant permissions to apps (Rectangle, Raycast, Docker)"
    echo "  4. Sign in to Tailscale and connect"
    echo ""
    log_info "Backup of original files: $BACKUP_DIR"
    log_info "If you encounter issues, see: ~/.dotfiles/README.md"
    echo ""
}

# ============================================================================
# Run Main Function
# ============================================================================

main "$@"
