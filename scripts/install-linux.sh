#!/usr/bin/env bash
# Linux installation script for standalone home-manager
# This script installs Nix and home-manager on any Linux system

set -e

echo "===================================="
echo "Nix + Home Manager Linux Installer"
echo "===================================="
echo ""

NIX_JUST_INSTALLED=false

# Check if Nix is already installed
if command -v nix &> /dev/null; then
    echo "✓ Nix is already installed"
else
    echo "Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon
    NIX_JUST_INSTALLED=true
    echo "✓ Nix installed successfully"
fi

# Always source nix profile to ensure it's available in current session
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# If Nix was just installed, we need to restart the script in a new shell
if [ "$NIX_JUST_INSTALLED" = true ] && [ -z "$NIX_INSTALLER_RERUN" ]; then
    echo ""
    echo "Nix was just installed. Restarting script in a new environment..."
    echo ""
    export NIX_INSTALLER_RERUN=1
    exec bash "$0" "$@"
fi

# Enable flakes
echo "Enabling Nix flakes..."
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# Restart nix-daemon to pick up the new config
echo "Restarting Nix daemon..."
if command -v systemctl &> /dev/null; then
    sudo systemctl restart nix-daemon
elif [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    # Source nix profile if systemctl not available
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

echo "✓ Flakes enabled"

# Clone or update config repository
if [ -d ~/.config/nix/.git ]; then
    echo "Updating existing configuration..."
    cd ~/.config/nix
    git pull
else
    echo "Cloning configuration repository..."
    # Remove existing ~/.config/nix if it exists and is not a git repo
    if [ -d ~/.config/nix ]; then
        mv ~/.config/nix ~/.config/nix.backup.$(date +%s)
    fi
    git clone https://github.com/ankushKun/nix.git ~/.config/nix
    cd ~/.config/nix
fi

# Get username and hostname
USERNAME=$(whoami)
HOSTNAME=$(hostname)

echo ""
echo "Detected configuration:"
echo "  Username: $USERNAME"
echo "  Hostname: $HOSTNAME"
echo ""
read -p "Is this correct? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter username: " USERNAME
    read -p "Enter hostname: " HOSTNAME
fi

echo ""
echo "Installing home-manager configuration..."
echo "Configuration: $USERNAME@$HOSTNAME"

# Update flake.nix with the actual username@hostname (only if not already updated)
if grep -q "\"username@hostname\"" ~/.config/nix/flake.nix 2>/dev/null; then
    echo "Updating flake.nix with your username@hostname..."
    sed -i "s/\"username@hostname\"/\"$USERNAME@$HOSTNAME\"/g" ~/.config/nix/flake.nix
else
    echo "Flake already configured for: $(grep -oP '"\K[^"]+@[^"]+' ~/.config/nix/flake.nix | head -1)"
fi

# Install home-manager (with explicit experimental features in case daemon restart didn't work)
echo ""
echo "Installing home-manager and all packages (this may take a few minutes)..."
nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake ~/.config/nix#$USERNAME@$HOSTNAME

# Source home-manager session variables to get zsh in PATH
if [ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
    . ~/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

# Change default shell to zsh (now that home-manager has installed it)
echo ""
echo "Setting zsh as default shell..."

# Find zsh in home-manager profile
ZSH_PATH="$HOME/.nix-profile/bin/zsh"

# Fallback to system zsh if home-manager one doesn't exist
if [ ! -f "$ZSH_PATH" ]; then
    ZSH_PATH=$(which zsh 2>/dev/null)
fi

if [ -f "$ZSH_PATH" ]; then
    # Add zsh to /etc/shells if not already there
    if ! grep -q "^$ZSH_PATH$" /etc/shells 2>/dev/null; then
        echo "Adding $ZSH_PATH to /etc/shells..."
        echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
    fi

    # Change default shell
    sudo chsh -s "$ZSH_PATH" "$USERNAME"
    echo "✓ Default shell changed to zsh ($ZSH_PATH)"
else
    echo "⚠ Warning: Could not find zsh, skipping shell change"
    echo "  You can manually install zsh and run: chsh -s \$(which zsh)"
fi

echo ""
echo "================================"
echo "✓ Installation complete!"
echo "================================"
echo ""
echo "Next steps:"
echo "  1. Log out and log back in (or run: exec zsh)"
echo "  2. To update your configuration: hm"
echo "  3. To edit your config: cd ~/.config/nix"
echo ""
