#!/usr/bin/env bash
# Automated installation script for Nix Darwin configuration on fresh macOS machine

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="git@github.com:ankushKun/nix.git"
INSTALL_DIR="$HOME/.config/nix"
FLAKE_NAME="simple"

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Nix Darwin Configuration Installer      ║${NC}"
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo ""

# Function to print status messages
print_status() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only"
    exit 1
fi

print_success "Running on macOS"

# Step 1: Check if Nix is already installed
print_status "Checking for Nix installation..."
if command -v nix &> /dev/null; then
    print_success "Nix is already installed"
    NIX_ALREADY_INSTALLED=true
else
    print_warning "Nix not found, will install"
    NIX_ALREADY_INSTALLED=false
fi

# Step 2: Install Nix if not present
if [ "$NIX_ALREADY_INSTALLED" = false ]; then
    print_status "Installing Nix (multi-user installation)..."
    echo -e "${YELLOW}This will require sudo access${NC}"

    if sh <(curl -L https://nixos.org/nix/install); then
        print_success "Nix installed successfully"

        # Source Nix profile
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
    else
        print_error "Nix installation failed"
        exit 1
    fi
else
    # Source Nix profile if needed
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
fi

# Step 3: Configure Nix for flakes
print_status "Configuring Nix for flakes and nix-command..."

NIX_CONF_DIR="$HOME/.config/nix"
mkdir -p "$NIX_CONF_DIR"

if [ -f "$NIX_CONF_DIR/nix.conf" ]; then
    if grep -q "experimental-features" "$NIX_CONF_DIR/nix.conf"; then
        print_success "Flakes already enabled in user config"
    else
        echo "experimental-features = nix-command flakes" >> "$NIX_CONF_DIR/nix.conf"
        print_success "Enabled flakes in user config"
    fi
else
    echo "experimental-features = nix-command flakes" > "$NIX_CONF_DIR/nix.conf"
    print_success "Created nix.conf with flakes enabled"
fi

# Step 4: Check for SSH access to GitHub
print_status "Checking SSH access to GitHub..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    print_success "GitHub SSH access confirmed"
    USE_SSH=true
else
    print_warning "SSH access to GitHub not configured"
    echo -e "${YELLOW}You can either:${NC}"
    echo "  1. Set up SSH keys now (recommended)"
    echo "  2. Use HTTPS to clone (will be asked for credentials)"
    read -p "Use HTTPS instead of SSH? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        REPO_URL="https://github.com/ankushKun/nix.git"
        USE_SSH=false
    else
        print_error "Please set up SSH keys and run this script again"
        echo "See: https://docs.github.com/en/authentication/connecting-to-github-with-ssh"
        exit 1
    fi
fi

# Step 5: Clone or update repository
if [ -d "$INSTALL_DIR/.git" ]; then
    print_status "Configuration directory already exists"
    read -p "Do you want to pull latest changes? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd "$INSTALL_DIR"
        git pull
        print_success "Repository updated"
    fi
else
    print_status "Cloning configuration repository..."
    if [ -d "$INSTALL_DIR" ] && [ "$(ls -A $INSTALL_DIR)" ]; then
        print_error "Directory $INSTALL_DIR exists and is not empty"
        print_warning "Please backup or remove it first"
        exit 1
    fi

    git clone "$REPO_URL" "$INSTALL_DIR"
    print_success "Repository cloned to $INSTALL_DIR"
fi

# Step 6: Check hostname
print_status "Checking system hostname..."
CURRENT_HOSTNAME=$(scutil --get ComputerName 2>/dev/null || hostname)
print_warning "Current hostname: $CURRENT_HOSTNAME"
print_warning "Flake is configured for hostname: $FLAKE_NAME"

if [ "$CURRENT_HOSTNAME" != "$FLAKE_NAME" ]; then
    echo ""
    echo "You can either:"
    echo "  1. Rename your machine to '$FLAKE_NAME'"
    echo "  2. Continue with current hostname (you'll need to update flake.nix later)"
    read -p "Rename machine to '$FLAKE_NAME'? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo scutil --set ComputerName "$FLAKE_NAME"
        sudo scutil --set LocalHostName "$FLAKE_NAME"
        sudo scutil --set HostName "$FLAKE_NAME"
        print_success "Hostname changed to $FLAKE_NAME"
    else
        print_warning "You may need to update the hostname in flake.nix"
    fi
fi

# Step 7: Run the initial Darwin rebuild
print_status "Building and applying Nix Darwin configuration..."
echo -e "${YELLOW}This may take a while on first run...${NC}"
echo ""

cd "$INSTALL_DIR"

if nix run nix-darwin -- switch --flake "$INSTALL_DIR#$FLAKE_NAME"; then
    print_success "Nix Darwin configuration applied successfully!"
else
    print_error "Configuration build failed"
    echo ""
    echo "You can try running manually with:"
    echo "  cd $INSTALL_DIR"
    echo "  nix run nix-darwin -- switch --flake .#$FLAKE_NAME"
    exit 1
fi

# Step 8: Make scripts executable
print_status "Setting up helper scripts..."
chmod +x "$INSTALL_DIR/scripts/backup.sh" "$INSTALL_DIR/scripts/restore.sh" 2>/dev/null || true
print_success "Scripts are ready to use"

# Final message
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Installation Complete! 🎉         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Future rebuilds: darwin-rebuild switch --flake $INSTALL_DIR#$FLAKE_NAME"
echo ""
echo -e "${BLUE}Helper scripts:${NC}"
echo "  • Backup to GitHub: $INSTALL_DIR/scripts/backup.sh"
echo "  • Restore from GitHub: $INSTALL_DIR/scripts/restore.sh"
echo ""
echo -e "${GREEN}Enjoy your configured system!${NC}"
