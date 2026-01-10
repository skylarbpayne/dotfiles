# Dotfiles

Automated macOS bootstrap system for homelab Mac mini with minimal, focused configurations.

## Features

- **Single-Command Setup**: Run one script to configure everything
- **Shell**: Zsh with Oh-My-Zsh, autosuggestions, syntax highlighting, and fzf
- **Editor**: Vim/Neovim with vim-plug and coc.nvim for modern LSP support
- **Terminal**: Tmux with custom keybindings and vim integration
- **Version Managers**: nvm (Node.js), uv (Python)
- **Settings Sync**: Mackup with Google Drive backend
- **macOS Defaults**: Automated system configuration for developer workflow
- **Safe & Idempotent**: Backs up existing files, safe to re-run

## Quick Start

### First-Time Setup (New Mac)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/skylarbpayne/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the bootstrap script:**
   ```bash
   ./bootstrap.sh
   ```

   The script will:
   - Install Xcode Command Line Tools
   - Generate SSH key (ed25519) and pause for GitHub setup
   - Install Homebrew package manager
   - Configure Git with your identity
   - Install CLI tools (vim, tmux, zsh, git, gh, htop, jq, fzf, ripgrep, bat, eza, etc.)
   - Install GUI applications (Chrome, VS Code, iTerm2, Rectangle, Raycast, Obsidian, Docker)
   - Install Claude Code CLI (via official installer)
   - Install version managers (nvm, uv)
   - Set up Oh-My-Zsh with plugins
   - Symlink dotfiles (with backup to `~/.dotfiles_backup_YYYYMMDD_HHMMSS/`)
   - Install vim-plug and coc.nvim
   - Configure macOS system settings
   - Set up Mackup for settings sync

3. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

4. **Verify installation:**
   ```bash
   ~/.dotfiles/scripts/verify.sh
   ```

### Updating Dotfiles

```bash
cd ~/.dotfiles
git pull origin master
./bootstrap.sh  # Safe to run multiple times
```

## Manual Steps

The bootstrap script will pause at these points:

### 1. SSH Key Setup
- Script generates an ed25519 SSH key
- Copies public key to clipboard
- **PAUSES** with instructions to add key to GitHub
- Visit: https://github.com/settings/keys
- Add the key and press any key to continue

### 2. Google Drive Setup for Mackup
- Sign in to Google Drive in System Preferences > Internet Accounts
- Enable Google Drive sync
- Wait for initial sync
- Run `mackup restore` to restore settings (or `mackup backup` for first-time backup)

### 3. Application Permissions (After Bootstrap)
- **Rectangle**: Grant Accessibility permissions in System Preferences
- **Raycast**: Grant Accessibility + Automation permissions
- **Docker Desktop**: Start app and accept license
- **Tailscale**: Sign in and connect to your network
- **iTerm2**: Set as default terminal (optional)

## Configuration Details

### Installed Software

**CLI Tools - Core:**
- zsh, tmux, vim, neovim, git, gh (GitHub CLI)

**CLI Tools - Monitoring/Ops:**
- htop, ncdu, jq, yq, fzf, ripgrep, bat, eza, fd, tldr

**CLI Tools - Development:**
- mackup, node

**Infrastructure:**
- tailscale

**GUI Applications:**
- Google Chrome
- Rectangle (window management)
- Raycast (launcher)
- iTerm2 (terminal)
- Visual Studio Code
- Obsidian (notes)
- Docker Desktop

**Version Managers:**
- nvm (Node.js)
- uv (Python)

**Zsh Plugins:**
- git (Oh-My-Zsh default)
- zsh-autosuggestions
- zsh-syntax-highlighting
- fzf integration

**Vim Plugins:**
- coc.nvim (LSP-based intellisense)
- vim-tmux-navigator (seamless vim/tmux navigation)
- julia-vim (Julia language support)

### Dotfile Structure

```
~/.dotfiles/           # Repository
├── .zshrc            → ~/.zshrc
├── .bashrc           → ~/.bashrc
├── .bash_profile     → ~/.bash_profile
├── .vimrc            → ~/.vimrc
├── .tmux.conf        → ~/.tmux.conf
├── .gitconfig        → ~/.gitconfig
├── .mackup.cfg       → ~/.mackup.cfg
└── init.vim          → ~/.config/nvim/init.vim
```

All dotfiles are **symlinked** from the repository to your home directory, making updates easy.

### Key Bindings

**Tmux:**
- Prefix: `Ctrl+N` (instead of default `Ctrl+B`)
- Navigate panes: `Ctrl+h/j/k/l` (works seamlessly with vim)
- Split horizontal: `Prefix + h`
- Split vertical: `Prefix + v`
- Reload config: `Prefix + Ctrl+R`

**Vim/Neovim:**
- Leader: `,`
- Quick escape: `jk` (in insert mode)
- Save: `<leader>w`
- Quit: `<leader>q`
- Edit .vimrc: `<leader>ev`
- Reload .vimrc: `<leader>sv`
- Clear search: `<leader><space>`
- Show documentation: `K`
- Go to definition: `gd`
- Go to references: `gr`
- Navigate diagnostics: `[g` / `]g`
- Rename symbol: `<leader>rn`
- Format selection: `<leader>f`
- Fix current: `<leader>qf`
- Toggle paste mode: `F2`
- Command shortcut: `;` (instead of `:`)

**Zsh:**
- Fuzzy history search: `Ctrl+R` (fzf)
- Fuzzy file search: `Ctrl+T` (fzf)
- Fuzzy directory change: `Alt+C` (fzf)

### Aliases

**Git:**
- `gs` - git status
- `gd` - git diff
- `gc` - git commit
- `gp` - git push
- `gl` - git log --oneline --graph

**Tmux:**
- `ta` - tmux attach
- `tl` - tmux list-sessions
- `tn` - tmux new -s

**Vim:**
- `v` - vim
- `nv` - nvim

**Docker:**
- `d` - docker
- `dc` - docker compose
- `dps` - docker ps

**Tools:**
- `cat` - bat (if available)
- `ls` - eza (if available, fallback to ls -GFh)
- `ll` - eza -l / ls -lh
- `la` - eza -la / ls -lAh
- `tree` - eza --tree

**Navigation:**
- `..` - cd ..
- `...` - cd ../..
- `....` - cd ../../..

### macOS Settings Applied

**Finder:**
- Show hidden files
- Show all file extensions
- Show status bar and path bar
- No .DS_Store on network/USB volumes
- List view by default
- Disable extension change warning

**Dock:**
- Icon size: 36px
- Auto-hide with no delay
- No recent applications
- Minimize to application icon

**Keyboard:**
- Fast key repeat (KeyRepeat: 2, InitialKeyRepeat: 15)
- Full keyboard access

**Trackpad:**
- Tap to click enabled

**Screenshots:**
- Save to: `~/Pictures/Screenshots`
- Format: PNG
- No shadow

**General:**
- Save to disk by default (not iCloud)
- Expand save/print dialogs
- No "Are you sure?" dialog for opening apps

**Safari:**
- Show full URL
- Enable Develop menu

**After Configuration:**
- Finder, Dock, and SystemUIServer are restarted
- Some changes require logout/restart

## Troubleshooting

### Vim Plugins Not Installing

```bash
vim +PlugInstall +qall
nvim --headless +PlugInstall +qall
```

### coc.nvim Not Working

1. Verify Node.js: `node --version`
2. Install coc extensions: `:CocInstall coc-json coc-tsserver`
3. Check coc status: `:CocInfo`

### Symlinks Not Created

```bash
cd ~/.dotfiles
./scripts/08-symlinks.sh
```

### Oh-My-Zsh Plugins Not Loading

```bash
# Verify plugin directories
ls -la ~/.oh-my-zsh/custom/plugins/

# Re-source configuration
source ~/.zshrc
```

### Mackup Issues

```bash
# Check configuration
cat ~/.mackup.cfg

# List supported applications
mackup list

# Uninstall symlinks (restore originals)
mackup uninstall
```

### Homebrew Issues

```bash
# Update Homebrew
brew update && brew upgrade

# Check for issues
brew doctor

# Reinstall if needed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Repository Structure

```
dotfiles/
├── bootstrap.sh              # Main entry point
├── scripts/
│   ├── 01-xcode.sh          # Xcode CLI tools
│   ├── 02-ssh.sh            # SSH key generation
│   ├── 03-homebrew.sh       # Homebrew installation
│   ├── 04-git-config.sh     # Git configuration
│   ├── 05-packages.sh       # Package installation
│   ├── 06-version-managers.sh # nvm, uv
│   ├── 07-zsh.sh            # Oh-My-Zsh setup
│   ├── 08-symlinks.sh       # Dotfile symlinking
│   ├── 09-vim-setup.sh      # Vim plugin installation
│   ├── 10-macos-defaults.sh # System settings
│   ├── 11-mackup.sh         # Mackup setup
│   └── verify.sh            # Verification script
├── config/
│   └── packages.sh          # Package definitions
├── .vimrc                   # Vim configuration
├── .zshrc                   # Zsh configuration
├── .tmux.conf               # Tmux configuration
├── .bashrc                  # Bash runtime config
├── .bash_profile            # Bash login config
├── init.vim                 # Neovim configuration
├── .mackup.cfg              # Mackup settings
├── .gitconfig               # Git configuration
└── README.md                # This file
```

## Philosophy

These dotfiles follow a **minimal** approach:
- Only essential configurations
- Prefer defaults when reasonable
- No unnecessary plugins or features
- Easy to understand and maintain
- Clean, well-documented code

## Backup

Original dotfiles are backed up before symlinking:
```
~/.dotfiles_backup_YYYYMMDD_HHMMSS/
```

You can restore by copying files back from this directory.

## Maintenance

### Weekly
```bash
# Update Homebrew packages
brew update && brew upgrade && brew cleanup

# Update Oh-My-Zsh
cd ~/.oh-my-zsh && git pull && cd -

# Update vim plugins
vim +PlugUpdate +qall
```

### Monthly
```bash
# Update Node.js LTS via nvm
nvm install --lts
nvm use --lts

# Update Python via uv
uv self update

# Backup settings with Mackup
mackup backup
```

### As Needed
```bash
# Pull dotfiles updates
cd ~/.dotfiles && git pull

# Re-run bootstrap (safe, idempotent)
./bootstrap.sh

# Verify everything
./scripts/verify.sh
```

## Contributing

These are personal dotfiles, but feel free to fork and adapt for your own use!

## License

MIT

## Author

Skylar Payne (me@skylarbpayne.com)

## Acknowledgments

Inspired by:
- https://github.com/mathiasbynens/dotfiles
- https://github.com/holman/dotfiles
- https://dotfiles.github.io
