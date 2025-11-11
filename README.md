# nix

Weeblet's Nix Darwin Configuration

## Fresh Machine Setup

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

### Post-Installation

After the initial setup, you can use the included scripts:

- **Backup changes to GitHub**:
```bash
~/.config/nix/scripts/backup.sh "Your commit message"
```

- **Restore from GitHub** (on any machine):
```bash
~/.config/nix/scripts/restore.sh
```

## What's Included

- **Nix Darwin**: System-level macOS configuration
- **Home Manager**: User-level dotfiles and packages
- **Configurations**: zsh, kitty, tmux, lvim, Rectangle, and more
- **Automated backup/restore**: Scripts for easy syncing with GitHub

## Troubleshooting

- If `darwin-rebuild` is not found after first install, restart your terminal
- Make sure your SSH keys are set up for GitHub access
- Check that experimental features are enabled in your Nix config
