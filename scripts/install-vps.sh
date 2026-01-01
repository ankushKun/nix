#!/usr/bin/env bash
# VPS installation script for standalone home-manager
# This script installs Nix and home-manager on a Linux VPS

set -e

echo "================================"
echo "Nix + Home Manager VPS Installer"
echo "================================"
echo ""

# Check if Nix is already installed
if command -v nix &> /dev/null; then
    echo "✓ Nix is already installed"
else
    echo "Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon

    # Source nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi

    echo "✓ Nix installed successfully"
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

# Update hosts/vps/default.nix with username
echo "Updating VPS configuration..."
sed -i "s/YOUR_VPS_USERNAME/$USERNAME/g" ~/.config/nix/hosts/vps/default.nix

echo ""
echo "Installing home-manager configuration..."
echo "Configuration: $USERNAME@$HOSTNAME"

# Update flake.nix with the actual username@hostname
sed -i "s/\"username@hostname\"/\"$USERNAME@$HOSTNAME\"/g" ~/.config/nix/flake.nix

# Install home-manager (with explicit experimental features in case daemon restart didn't work)
nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake ~/.config/nix#$USERNAME@$HOSTNAME

echo ""
echo "================================"
echo "✓ Installation complete!"
echo "================================"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. To update your configuration: hm"
echo "  3. To edit your config: cd ~/.config/nix"
echo ""
