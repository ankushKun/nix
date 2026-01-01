# nix

Weeblet's Multi-Platform Nix Configuration

A unified Nix configuration for both **macOS** (via nix-darwin) and **Linux** (via standalone home-manager), sharing common dotfiles and packages across platforms.

Works on: macOS, Linux servers, Linux desktops, WSL, and more!

## macOS Setup

Run this single command to automatically install everything:

```bash
bash <(curl -L https://raw.githubusercontent.com/ankushKun/nix/main/scripts/install.sh)
```

This script will:
- Install Nix if not present
- Enable flakes and nix-command
- Clone this repository
- Apply the Nix Darwin configuration
- Set up all your dotfiles and packages

**That's it!** The script handles everything automatically.

### Updating macOS Configuration

```bash
dr  # Alias for: sudo darwin-rebuild switch --flake ~/.config/nix#weeblets-mbp
```

## Linux Setup

Works on any Linux distribution: Ubuntu, Debian, Arch, Fedora, NixOS, WSL, and more!

### Automated Installation

Run this single command on your Linux system:

```bash
bash <(curl -L https://raw.githubusercontent.com/ankushKun/nix/main/scripts/install-linux.sh)
```

This script will:
- Install Nix (multi-user installation)
- Enable flakes
- Clone this repository
- Auto-detect your username from `$USER`
- Apply the home-manager configuration
- Set up all shared dotfiles (neovim, zsh, tmux, etc.)
- Set zsh as your default shell

### Manual Installation

If you prefer manual installation:

1. **Install Nix**:
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

2. **Enable flakes**:
   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
   ```

3. **Clone repository**:
   ```bash
   git clone https://github.com/ankushKun/nix.git ~/.config/nix
   cd ~/.config/nix
   ```

4. **Apply configuration**:
   ```bash
   nix run home-manager/master -- switch --flake ~/.config/nix#linux
   ```

   Note: Your username is automatically detected from the `$USER` environment variable at runtime.

### Updating Linux Configuration

```bash
hm  # Alias for: home-manager switch --flake ~/.config/nix#linux
```

## What's Shared Between Platforms

The following configurations work identically on both macOS and Linux:

- **Neovim**: Complete editor configuration with LSP, plugins, and themes
- **Zsh**: Shell with Powerlevel10k theme, autosuggestions, and syntax highlighting
- **Tmux**: Terminal multiplexer configuration
- **Git**: Version control settings
- **CLI Tools**: ripgrep, fd, fzf, lazygit, bat, eza, direnv
- **Development Tools**: Language servers, runtimes (Node.js, Go, Rust)

## What's Platform-Specific

### macOS Only
- **System Settings**: Dock, Finder, Trackpad preferences
- **Homebrew**: Package management
- **GUI Apps**: Kitty, Discord, Rectangle, Claude Code
- **Docker**: Uses Colima

### Linux Only
- **Flexible**: Can be configured for servers (minimal) or desktops (with GUI apps)
- **Docker**: Native Docker support (no Colima needed)

## Configuration Management

### Backup Changes to GitHub

```bash
~/.config/nix/scripts/backup.sh "Your commit message"
```

### Restore from GitHub

```bash
~/.config/nix/scripts/restore.sh
```

## Directory Structure

```
~/.config/nix/
├── flake.nix                 # Multi-platform flake configuration
├── modules/
│   ├── common/              # Shared cross-platform configs
│   │   ├── home.nix         # Main entry point
│   │   ├── shell.nix        # Zsh configuration
│   │   ├── neovim.nix       # Neovim configuration
│   │   ├── git.nix          # Git configuration
│   │   └── packages.nix     # Common packages
│   ├── darwin/              # macOS-specific
│   │   ├── system.nix       # System defaults
│   │   └── gui.nix          # GUI applications
│   ├── darwin.nix           # Darwin system config
│   ├── home-manager.nix     # macOS home-manager config
│   └── packages.nix         # Package definitions
├── hosts/
│   └── linux/
│       └── default.nix      # Linux configuration
├── configs/
│   ├── shared/              # Cross-platform dotfiles
│   │   ├── nvim-init.lua
│   │   ├── zshrc
│   │   ├── tmux.conf
│   │   └── p10k.zsh
│   └── darwin/              # macOS-specific dotfiles
│       ├── kitty.conf
│       └── zshrc-darwin
└── scripts/
    ├── install.sh           # macOS installer
    ├── install-linux.sh     # Linux installer
    ├── backup.sh
    └── restore.sh
```

## Troubleshooting

### macOS
- If `darwin-rebuild` is not found after first install, restart your terminal
- Make sure your SSH keys are set up for GitHub access
- Check that experimental features are enabled in your Nix config

### Linux
- If `home-manager` command is not found, source your shell: `source ~/.zshrc` or `exec zsh`
- Ensure Nix daemon is running: `systemctl status nix-daemon`
- Check flakes are enabled: `cat ~/.config/nix/nix.conf`
- On WSL, you may need to restart the WSL instance after installation
