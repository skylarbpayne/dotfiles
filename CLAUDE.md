# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS dotfiles/bootstrap repository that configures a new Mac with a single command. It installs software via Homebrew, sets up shell environments (zsh with Oh-My-Zsh), configures vim/neovim, and applies macOS system defaults.

## Common Commands

```bash
# Full bootstrap (new machine setup)
./bootstrap.sh

# Verify installation after bootstrap
./scripts/verify.sh

# Run individual setup scripts
./scripts/08-symlinks.sh    # Re-create dotfile symlinks
./scripts/09-vim-setup.sh   # Reinstall vim plugins
./scripts/10-macos-defaults.sh  # Reapply macOS settings

# One-line remote install
curl -fsSL https://raw.githubusercontent.com/skylarbpayne/dotfiles/main/install.sh | bash
```

## Architecture

### Bootstrap Flow
`bootstrap.sh` orchestrates 11 numbered scripts in `scripts/` that run sequentially:
1. Xcode CLI tools → 2. SSH key → 3. Homebrew → 4. Git config → 5. Packages → 6. Version managers → 7. Zsh/Oh-My-Zsh → 8. Symlinks → 9. Vim setup → 10. macOS defaults → 11. Mackup

The numbered prefix determines execution order. Each script is idempotent and safe to re-run.

### Package Definitions
All Homebrew packages (CLI and GUI casks) are defined in `config/packages.sh` as bash arrays. Modify this file to add/remove software.

### Dotfile Symlinks
The root dotfiles (`.zshrc`, `.vimrc`, `.tmux.conf`, `.gitconfig`, `.mackup.cfg`, `.bashrc`, `.bash_profile`, `init.vim`) get symlinked to `$HOME` by `scripts/08-symlinks.sh`. Original files are backed up to `~/.dotfiles_backup_YYYYMMDD_HHMMSS/`.

### Error Handling
`bootstrap.sh` uses `set -e -u -o pipefail` with an error trap that reports the failing line number and backup location.

## Key Conventions

- Scripts use color-coded logging functions: `log_info`, `log_warn`, `log_error`, `log_section`
- All scripts assume `$DOTFILES_DIR` is `$HOME/.dotfiles`
- The repository follows a minimal philosophy: only essential configurations, prefer defaults
