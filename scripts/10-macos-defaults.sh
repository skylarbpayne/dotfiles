#!/usr/bin/env bash

# ============================================================================
# macOS Defaults Configuration
# Configure macOS system settings for a developer-friendly experience
# ============================================================================

configure_macos_defaults() {
    log_info "Configuring macOS system settings..."

    # Close System Preferences to prevent conflicts
    osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

    ###########################################################################
    # General UI/UX                                                           #
    ###########################################################################

    log_info "Configuring general UI/UX..."

    # Expand save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

    # Expand print panel by default
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

    # Save to disk (not to iCloud) by default
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

    # Disable the "Are you sure you want to open this application?" dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    ###########################################################################
    # Trackpad, mouse, keyboard, and input                                    #
    ###########################################################################

    log_info "Configuring input devices..."

    # Trackpad: enable tap to click
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # Enable full keyboard access for all controls
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    # Set fast key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    ###########################################################################
    # Finder                                                                  #
    ###########################################################################

    log_info "Configuring Finder..."

    # Show hidden files by default
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Show status bar
    defaults write com.apple.finder ShowStatusBar -bool true

    # Show path bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Keep folders on top when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Disable the warning when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Use list view in all Finder windows by default
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    ###########################################################################
    # Dock                                                                    #
    ###########################################################################

    log_info "Configuring Dock..."

    # Set the icon size of Dock items to 36 pixels
    defaults write com.apple.dock tilesize -int 36

    # Minimize windows into their application's icon
    defaults write com.apple.dock minimize-to-application -bool true

    # Show indicator lights for open applications
    defaults write com.apple.dock show-process-indicators -bool true

    # Don't show recent applications in Dock
    defaults write com.apple.dock show-recents -bool false

    # Automatically hide and show the Dock
    defaults write com.apple.dock autohide -bool true

    # Remove the auto-hiding Dock delay
    defaults write com.apple.dock autohide-delay -float 0

    # Speed up Mission Control animations
    defaults write com.apple.dock expose-animation-duration -float 0.1

    ###########################################################################
    # Safari & WebKit                                                         #
    ###########################################################################

    # Note: Safari preferences are sandboxed on modern macOS and cannot be
    # modified via defaults command. These settings must be configured manually
    # in Safari > Preferences:
    # - Show full URL in address bar (Preferences > Advanced)
    # - Enable Develop menu (Preferences > Advanced > Show Develop menu)

    log_info "Skipping Safari configuration (sandboxed on modern macOS)"

    ###########################################################################
    # Terminal                                                                #
    ###########################################################################

    log_info "Configuring Terminal..."

    # Only use UTF-8 in Terminal.app
    defaults write com.apple.terminal StringEncodings -array 4

    ###########################################################################
    # Activity Monitor                                                        #
    ###########################################################################

    log_info "Configuring Activity Monitor..."

    # Show the main window when launching
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

    # Show all processes
    defaults write com.apple.ActivityMonitor ShowCategory -int 0

    # Sort by CPU usage
    defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
    defaults write com.apple.ActivityMonitor SortDirection -int 0

    ###########################################################################
    # Screenshots                                                             #
    ###########################################################################

    log_info "Configuring screenshots..."

    # Save screenshots to ~/Pictures/Screenshots
    mkdir -p "$HOME/Pictures/Screenshots"
    defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

    # Save screenshots in PNG format
    defaults write com.apple.screencapture type -string "png"

    # Disable shadow in screenshots
    defaults write com.apple.screencapture disable-shadow -bool true

    ###########################################################################
    # Kill affected applications                                              #
    ###########################################################################

    log_info "Restarting affected applications..."

    for app in "Activity Monitor" \
        "Dock" \
        "Finder" \
        "SystemUIServer"; do
        killall "${app}" &> /dev/null || true
    done

    log_info "✓ macOS defaults configured successfully"
    log_warn ""
    log_warn "Note: Some changes may require a logout/restart to take full effect"
}

# Run macOS defaults configuration
configure_macos_defaults
