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
FLAKE_NAME="weeblets-mbp"

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

# Step 1: Check and install Xcode Command Line Tools
print_status "Checking for Xcode Command Line Tools..."
if xcode-select -p &> /dev/null; then
    print_success "Xcode Command Line Tools already installed"
else
    print_warning "Xcode Command Line Tools not found"
    print_status "Installing Xcode Command Line Tools..."
    echo -e "${YELLOW}A dialog will appear - please click 'Install' and wait for completion${NC}"

    # Trigger the installation
    xcode-select --install &> /dev/null || true

    # Wait for installation to complete
    echo -e "${YELLOW}Waiting for Xcode Command Line Tools installation...${NC}"
    until xcode-select -p &> /dev/null; do
        sleep 5
    done

    print_success "Xcode Command Line Tools installed successfully"
fi

# Step 2: Check if Nix is already installed
print_status "Checking for Nix installation..."
if command -v nix &> /dev/null; then
    print_success "Nix is already installed"
    NIX_ALREADY_INSTALLED=true
else
    print_warning "Nix not found, will install"
    NIX_ALREADY_INSTALLED=false
fi

# Step 3: Install Nix if not present
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

# Step 4: Configure Nix for flakes
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

# Step 5: Check for SSH keys and GitHub access
print_status "Checking for SSH keys..."

SSH_KEY_PATH="$HOME/.ssh/id_ed25519"
SSH_KEY_EXISTS=false

if [ -f "$SSH_KEY_PATH" ]; then
    print_success "SSH key found at $SSH_KEY_PATH"
    SSH_KEY_EXISTS=true
else
    print_warning "No SSH key found"
    read -p "Generate SSH key now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Generating SSH key..."

        # Get email for SSH key
        read -p "Enter your GitHub email: " GITHUB_EMAIL

        # Create .ssh directory if it doesn't exist
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"

        # Ask about passphrase
        echo ""
        echo -e "${YELLOW}GitHub recommends protecting your SSH key with a passphrase${NC}"
        read -p "Do you want to set a passphrase? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Generate SSH key with passphrase prompt
            ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$SSH_KEY_PATH"
            USE_KEYCHAIN=true
        else
            # Generate SSH key without passphrase
            ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$SSH_KEY_PATH" -N ""
            USE_KEYCHAIN=false
        fi

        print_success "SSH key generated at $SSH_KEY_PATH"
        SSH_KEY_EXISTS=true

        # Configure SSH config file
        print_status "Configuring SSH config..."
        SSH_CONFIG="$HOME/.ssh/config"

        # Create config file if it doesn't exist
        touch "$SSH_CONFIG"
        chmod 600 "$SSH_CONFIG"

        # Check if github.com host already exists in config
        if grep -q "^Host github.com" "$SSH_CONFIG"; then
            print_warning "GitHub host already configured in SSH config"
        else
            # Add GitHub SSH configuration
            cat >> "$SSH_CONFIG" << EOF

Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $SSH_KEY_PATH
EOF
            print_success "SSH config updated"
        fi
    fi
fi

# Add SSH key to ssh-agent if it exists
if [ "$SSH_KEY_EXISTS" = true ]; then
    print_status "Starting ssh-agent and adding key..."

    # Start ssh-agent
    eval "$(ssh-agent -s)" > /dev/null

    # Add SSH key to ssh-agent with keychain support
    # Try --apple-use-keychain first (newer macOS), fall back to -K (older macOS)
    if ssh-add --help 2>&1 | grep -q "apple-use-keychain"; then
        ssh-add --apple-use-keychain "$SSH_KEY_PATH" 2>/dev/null
    else
        ssh-add -K "$SSH_KEY_PATH" 2>/dev/null
    fi

    print_success "SSH key added to ssh-agent"
fi

# Check GitHub SSH access
print_status "Checking SSH access to GitHub..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    print_success "GitHub SSH access confirmed"
    USE_SSH=true
else
    if [ "$SSH_KEY_EXISTS" = true ]; then
        print_warning "SSH key exists but not added to GitHub yet"
        echo ""
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${YELLOW}Please add this SSH public key to your GitHub account:${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        cat "$SSH_KEY_PATH.pub"
        echo ""
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "${BLUE}Steps to add SSH key to GitHub:${NC}"
        echo "  1. Copy the key above"
        echo "  2. Go to: https://github.com/settings/ssh/new"
        echo "  3. Paste the key and click 'Add SSH key'"
        echo ""

        # Copy to clipboard if pbcopy is available
        if command -v pbcopy &> /dev/null; then
            cat "$SSH_KEY_PATH.pub" | pbcopy
            print_success "SSH key copied to clipboard!"
        fi

        echo -e "${YELLOW}For now, we'll use HTTPS to clone the repository${NC}"
        REPO_URL="https://github.com/ankushKun/nix.git"
        USE_SSH=false
    else
        print_warning "SSH access to GitHub not configured"
        echo -e "${YELLOW}Using HTTPS to clone the repository${NC}"
        REPO_URL="https://github.com/ankushKun/nix.git"
        USE_SSH=false
    fi
fi

# Step 6: Clone or update repository
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

    # Check if directory exists and has files other than nix.conf
    if [ -d "$INSTALL_DIR" ]; then
        # Check for files other than nix.conf using bash built-ins
        HAS_OTHER_FILES=false
        shopt -s nullglob dotglob
        for item in "$INSTALL_DIR"/*; do
            if [ "$(basename "$item")" != "nix.conf" ]; then
                HAS_OTHER_FILES=true
                break
            fi
        done
        shopt -u nullglob dotglob

        if [ "$HAS_OTHER_FILES" = true ]; then
            print_error "Directory $INSTALL_DIR exists and contains files"
            print_warning "Please backup or remove it first"
            exit 1
        fi

        # If only nix.conf exists, back it up temporarily
        if [ -f "$INSTALL_DIR/nix.conf" ]; then
            print_status "Backing up existing nix.conf..."
            mv "$INSTALL_DIR/nix.conf" "$INSTALL_DIR.nix.conf.backup"
        fi

        # Remove the directory to allow git clone
        rmdir "$INSTALL_DIR" 2>/dev/null || true
    fi

    git clone "$REPO_URL" "$INSTALL_DIR"
    print_success "Repository cloned to $INSTALL_DIR"

    # Restore nix.conf if it was backed up and doesn't exist in the repo
    if [ -f "$INSTALL_DIR.nix.conf.backup" ] && [ ! -f "$INSTALL_DIR/nix.conf" ]; then
        print_status "Restoring nix.conf..."
        mv "$INSTALL_DIR.nix.conf.backup" "$INSTALL_DIR/nix.conf"
    elif [ -f "$INSTALL_DIR.nix.conf.backup" ]; then
        # Clean up backup if repo already has nix.conf
        rm "$INSTALL_DIR.nix.conf.backup"
    fi
fi

# Step 7: Check hostname
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

# Step 8: Run the initial Darwin rebuild
print_status "Building and applying Nix Darwin configuration..."
echo -e "${YELLOW}This may take a while on first run...${NC}"
echo -e "${YELLOW}You will be prompted for your sudo password${NC}"
echo ""

cd "$INSTALL_DIR"

if sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake "$INSTALL_DIR#$FLAKE_NAME"; then
    print_success "Nix Darwin configuration applied successfully!"
else
    print_error "Configuration build failed"
    echo ""
    echo "You can try running manually with:"
    echo "  cd $INSTALL_DIR"
    echo "  sudo nix --extra-experimental-features \"nix-command flakes\" run nix-darwin -- switch --flake .#$FLAKE_NAME"
    exit 1
fi

# Step 9: Make scripts executable
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
