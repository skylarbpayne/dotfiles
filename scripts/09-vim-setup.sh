#!/usr/bin/env bash

# ============================================================================
# Vim Plugin Setup
# Install vim-plug and configure vim/neovim plugins
# ============================================================================

setup_vim_plugins() {
    log_info "Setting up Vim plugins..."

    # Clean up old Vundle installation if present
    if [[ -d "$HOME/.vim/bundle/Vundle.vim" ]] || [[ -d "$HOME/.vim/plugin/Vundle.vim" ]]; then
        log_info "Removing old Vundle installation..."
        rm -rf "$HOME/.vim/bundle"
        rm -rf "$HOME/.vim/plugin/Vundle.vim"
        log_info "  ✓ Vundle removed"
    fi

    # Install vim-plug for Vim
    VIM_PLUG_PATH="$HOME/.vim/autoload/plug.vim"
    if [[ ! -f "$VIM_PLUG_PATH" ]]; then
        log_info "Installing vim-plug for Vim..."
        curl -fLo "$VIM_PLUG_PATH" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        log_info "  ✓ vim-plug installed for Vim"
    else
        log_info "  ✓ vim-plug already installed for Vim"
    fi

    # Install vim-plug for Neovim
    NVIM_PLUG_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
    if [[ ! -f "$NVIM_PLUG_PATH" ]]; then
        log_info "Installing vim-plug for Neovim..."
        curl -fLo "$NVIM_PLUG_PATH" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        log_info "  ✓ vim-plug installed for Neovim"
    else
        log_info "  ✓ vim-plug already installed for Neovim"
    fi

    # Check if plugins already installed
    if [[ -d "$HOME/.vim/plugged" ]] && [[ -n "$(ls -A $HOME/.vim/plugged 2>/dev/null)" ]]; then
        log_info "Vim plugins already installed, updating..."
        vim +PlugUpdate +qall 2>/dev/null || log_warn "Vim plugin update may have issues"

        log_info "Updating Neovim plugins..."
        nvim --headless +PlugUpdate +qall 2>/dev/null || log_warn "Neovim plugin update may have issues"

        log_info "✓ Plugins updated"
    else
        # Install Vim plugins
        log_info "Installing Vim plugins..."
        vim +PlugInstall +qall 2>/dev/null || log_warn "Vim plugin installation may have issues"

        log_info "Installing Neovim plugins..."
        nvim --headless +PlugInstall +qall 2>/dev/null || log_warn "Neovim plugin installation may have issues"

        log_info "✓ Plugins installed"
    fi

    # Install coc extensions
    log_info "Installing coc.nvim extensions..."

    # Basic coc extensions for development
    COC_EXTENSIONS=(
        "coc-json"
        "coc-tsserver"
        "coc-html"
        "coc-css"
        "coc-python"
        "coc-sh"
        "coc-yaml"
    )

    for ext in "${COC_EXTENSIONS[@]}"; do
        log_info "  Installing $ext..."
        nvim --headless +"CocInstall -sync $ext" +qall 2>/dev/null || true
    done

    log_info "✓ Vim plugin setup complete"
    log_info ""
    log_info "Note: Run ':CocConfig' in vim/nvim to configure language servers"
    log_info "      Run ':PlugStatus' to verify plugin installations"
}

# Run vim setup
setup_vim_plugins
