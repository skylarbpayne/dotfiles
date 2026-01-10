#!/usr/bin/env bash

# ============================================================================
# Dotfiles Symlinking
# Safely symlink dotfiles from repository to home directory with backup
# ============================================================================

symlink_dotfiles() {
    log_info "Symlinking dotfiles from $DOTFILES_DIR to $HOME"

    # Files to symlink from repository to home directory
    DOTFILES=(
        ".zshrc"
        ".bashrc"
        ".bash_profile"
        ".vimrc"
        ".tmux.conf"
        ".gitconfig"
        ".mackup.cfg"
    )

    # Symlink regular dotfiles
    for file in "${DOTFILES[@]}"; do
        SOURCE="$DOTFILES_DIR/$file"
        TARGET="$HOME/$file"

        # Check if source exists
        if [[ ! -f "$SOURCE" ]]; then
            log_warn "Source file not found: $SOURCE"
            log_warn "Skipping $file"
            continue
        fi

        # Handle existing file or symlink
        if [[ -e "$TARGET" ]] || [[ -L "$TARGET" ]]; then
            if [[ -L "$TARGET" ]]; then
                # It's a symlink
                LINK_TARGET=$(readlink "$TARGET")
                if [[ "$LINK_TARGET" == "$SOURCE" ]]; then
                    log_info "  ✓ $file already correctly symlinked"
                    continue
                else
                    log_info "  Removing existing symlink: $file (pointed to $LINK_TARGET)"
                    rm "$TARGET"
                fi
            else
                # It's a regular file or directory
                log_info "  Backing up existing file: $file"
                mv "$TARGET" "$BACKUP_DIR/"
            fi
        fi

        # Create symlink
        log_info "  Creating symlink: $file"
        ln -s "$SOURCE" "$TARGET"
    done

    # Handle Neovim config separately
    log_info "Setting up Neovim config..."
    NVIM_CONFIG_DIR="$HOME/.config/nvim"
    mkdir -p "$NVIM_CONFIG_DIR"

    NVIM_SOURCE="$DOTFILES_DIR/init.vim"
    NVIM_TARGET="$NVIM_CONFIG_DIR/init.vim"

    if [[ ! -f "$NVIM_SOURCE" ]]; then
        log_warn "Source file not found: $NVIM_SOURCE"
        log_warn "Skipping Neovim config"
    else
        # Handle existing file or symlink
        if [[ -e "$NVIM_TARGET" ]] || [[ -L "$NVIM_TARGET" ]]; then
            if [[ -L "$NVIM_TARGET" ]]; then
                LINK_TARGET=$(readlink "$NVIM_TARGET")
                if [[ "$LINK_TARGET" == "$NVIM_SOURCE" ]]; then
                    log_info "  ✓ init.vim already correctly symlinked"
                else
                    log_info "  Removing existing symlink: init.vim"
                    rm "$NVIM_TARGET"
                    ln -s "$NVIM_SOURCE" "$NVIM_TARGET"
                    log_info "  Created symlink: init.vim"
                fi
            else
                log_info "  Backing up existing init.vim"
                mv "$NVIM_TARGET" "$BACKUP_DIR/"
                ln -s "$NVIM_SOURCE" "$NVIM_TARGET"
                log_info "  Created symlink: init.vim"
            fi
        else
            ln -s "$NVIM_SOURCE" "$NVIM_TARGET"
            log_info "  Created symlink: init.vim"
        fi
    fi

    # Verify symlinks
    log_info "Verifying symlinks..."
    local errors=0

    for file in "${DOTFILES[@]}"; do
        TARGET="$HOME/$file"
        if [[ -L "$TARGET" ]]; then
            log_info "  ✓ $file -> $(readlink "$TARGET")"
        else
            log_warn "  ✗ $file not symlinked"
            ((errors++))
        fi
    done

    if [[ -L "$NVIM_TARGET" ]]; then
        log_info "  ✓ init.vim -> $(readlink "$NVIM_TARGET")"
    else
        log_warn "  ✗ init.vim not symlinked"
        ((errors++))
    fi

    if [[ $errors -gt 0 ]]; then
        log_warn "Some symlinks were not created successfully"
    else
        log_info "✓ All symlinks created successfully"
    fi
}

# Run symlink creation
symlink_dotfiles
