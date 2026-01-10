# Changelog

## 2026-01-10 - Robustness Improvements (v4)

### Fixed: Safari Defaults Error
**Issue:** Safari preferences cannot be modified via `defaults` command on modern macOS due to sandboxing, causing the script to fail with permission errors.

**Fix:**
- Removed Safari defaults configuration
- Added comment explaining Safari is sandboxed and must be configured manually
- Removed Safari from the killall list at the end of the script

**Location:** `scripts/10-macos-defaults.sh`

**Manual Configuration:**
Users should configure Safari manually:
- Show full URL: Safari > Preferences > Advanced
- Enable Develop menu: Safari > Preferences > Advanced > Show Develop menu

### Removed: Unnecessary Confirmation Prompts
**Change:** Removed all confirmation prompts except for SSH key reuse (user requested).

**Removed Prompts:**
1. `bootstrap.sh` - "Continue with bootstrap?" → Now shows 3-second countdown with Ctrl+C option
2. `04-git-config.sh` - "Reconfigure Git settings?" → Always reconfigures
3. `07-zsh.sh` - "Update Oh-My-Zsh?" → Always updates
4. `09-vim-setup.sh` - "Reinstall/update vim plugins?" → Always updates
5. `10-macos-defaults.sh` - "Configure macOS system settings?" → Always configures
6. `11-mackup.sh` - "Do you want to restore settings from Mackup backup now?" → Always restores if backup exists

**Kept Prompt:**
- `02-ssh.sh` - "Generate a new SSH key (will backup existing)?" → **KEPT** (user preference)

**Rationale:**
If the user is running the bootstrap script, they want the installation to proceed. The only meaningful choice is whether to reuse an existing SSH key or generate a new one.

**Locations:** All script files mentioned above

## 2026-01-10 - Robustness Improvements (v3)

### Added: Automated Claude Code Installation
**Change:** Claude Code is now automatically installed using the official curl method from GitHub instead of just showing a warning.

**Implementation:**
- Uses official installer: `curl -fsSL https://raw.githubusercontent.com/anthropics/claude-code/main/install.sh | sh`
- Checks if Claude Code is already installed before attempting installation
- Displays version after successful installation
- Warns if installation succeeds but command not found in PATH (requires terminal restart)
- Falls back to manual installation instructions if curl method fails

**Location:** `scripts/05-packages.sh` (lines 115-138)

**Documentation:**
- Updated README.md to reflect automated installation
- Removed manual installation step from "Manual Steps" section
- Added Claude Code to the installation sequence list

## 2026-01-10 - Robustness Improvements (v2)

### Fixed: Unbound Variable Error in Package Installation
**Issue:** Script failed with "unbound variable" error when installing GUI applications because `INSTALL_FAILED` wasn't initialized before the conditional check.

**Fix:**
- Initialize `INSTALL_FAILED=false` before each installation attempt
- Works correctly with `set -u` (strict mode) in bootstrap script

**Location:** `scripts/05-packages.sh` (line 98)

## 2026-01-10 - Robustness Improvements (v1)

### Fixed: SSH GitHub Connection Verification
**Issue:** SSH connection test was not properly capturing GitHub's response, which exits with code 1 even on successful authentication.

**Fix:**
- Capture SSH output explicitly with `|| true` to prevent script exit
- Check for multiple success patterns: "successfully authenticated" and "Hi.*You've successfully authenticated"
- Display SSH output in warnings for easier debugging
- Applied to both new key generation and existing key verification paths

**Location:** `scripts/02-ssh.sh`

### Fixed: Homebrew Cask Installation Errors
**Issue:** Script would exit with error when trying to install a cask that was already manually installed (e.g., Chrome).

**Fix:**
- Added `is_app_installed()` helper function that checks:
  - If Homebrew knows about the cask (`brew list --cask`)
  - If the app exists in `/Applications` (manual installation)
- Capture installation output and detect "already an App" errors
- Display warning instead of failing when app is manually installed
- Applied error handling to all CLI package installations with `|| log_error`
- Script now continues even if individual packages fail to install

**Location:** `scripts/05-packages.sh`

### Improvements Made

1. **SSH Verification:**
   - More reliable GitHub connection testing
   - Better error messages with actual SSH output
   - Handles all GitHub response variations

2. **Package Installation:**
   - Gracefully handles pre-installed GUI apps
   - Continues installation even if individual packages fail
   - Clear distinction between Homebrew-managed and manual installations
   - Better error reporting without stopping the entire bootstrap

3. **Self-Healing:**
   - Script is now more resilient to existing installations
   - Can be re-run safely even with partially completed setups
   - Provides actionable warnings instead of hard failures

## Testing Recommendations

- Test with Chrome (or other app) already manually installed
- Test SSH verification with both new and existing keys
- Test re-running bootstrap after partial completion
- Verify error messages are clear and actionable
