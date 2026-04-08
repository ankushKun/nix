# nix

Weeblet's macOS Nix Configuration

A Nix configuration for **macOS** via nix-darwin and home-manager, managing system settings, dotfiles, and packages declaratively.

## Setup

Run this single command to automatically install everything:

```bash
bash <(curl -L https://raw.githubusercontent.com/ankushKun/nix/main/scripts/install.sh)
```

This script will:
- Install Xcode Command Line Tools
- Install Nix if not present
- Enable flakes and nix-command
- Set up SSH keys for GitHub
- Install Homebrew
- Clone this repository
- Apply the Nix Darwin configuration
- Set up all your dotfiles and packages

**That's it!** The script handles everything automatically.

## Updating Configuration

```bash
dr  # Alias for: sudo darwin-rebuild switch --flake ~/.config/nix#weeblets-mbp
```

## What's Managed

- **System Settings**: Dock, Finder, Trackpad preferences, Dark mode
- **Shell**: Zsh with Powerlevel10k, autosuggestions, syntax highlighting
- **Editor**: Neovim with LSP, plugins, and themes
- **Terminal**: Kitty with tmux auto-launch
- **Window Management**: Rectangle
- **CLI Tools**: ripgrep, fd, fzf, lazygit, bat, eza, direnv, jq
- **Development**: Go, Rust (rustup), Bun, Node (nvm), Docker/Colima
- **Git**: Version control settings
- **Homebrew**: Package management with auto-cleanup

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
├── flake.nix                 # Flake configuration
├── modules/
│   ├── home.nix              # Home Manager entry point
│   ├── shell.nix             # Zsh, fzf, bat, eza, direnv, tmux
│   ├── packages.nix          # CLI tools and dev packages
│   ├── git.nix               # Git configuration
│   ├── neovim.nix            # Neovim configuration
│   ├── home-manager.nix      # Home Manager module loader
│   ├── darwin.nix             # Darwin system config
│   └── darwin/
│       ├── system.nix         # macOS system defaults
│       └── gui.nix            # Kitty, Rectangle, Docker
├── configs/
│   ├── zshrc                  # Zsh init (p10k, ascii art, nvm)
│   ├── nvim-init.lua          # Neovim configuration
│   ├── tmux.conf              # Tmux configuration
│   ├── p10k.zsh              # Powerlevel10k theme
│   └── darwin/
│       ├── kitty.conf         # Kitty color scheme
│       └── rectangle.json     # Rectangle settings
└── scripts/
    ├── install.sh             # macOS installer
    ├── backup.sh
    └── restore.sh
```

## Troubleshooting

- If `darwin-rebuild` is not found after first install, restart your terminal
- Make sure your SSH keys are set up for GitHub access
- Check that experimental features are enabled: `cat ~/.config/nix/nix.conf`
