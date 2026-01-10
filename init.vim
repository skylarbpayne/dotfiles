" ============================================================================
" Neovim Configuration
" Minimal setup with vim-plug and coc.nvim
" ============================================================================

" Source vim configuration for compatibility
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Source main vimrc
source ~/.vimrc

" ============================================================================
" Neovim-specific Settings
" ============================================================================

" Use system clipboard
set clipboard+=unnamedplus

" True color support
if (has("termguicolors"))
    set termguicolors
endif

" Mouse support
set mouse=a

" ============================================================================
" Additional Neovim Configuration
" ============================================================================

" Add any Neovim-specific settings here
