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
- **File Explorer**: Yazi with Tokyo Night theming, image previews, git status
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

## Yazi (Terminal File Explorer)

Yazi is a fast terminal file manager, themed to match the rest of the
terminal apps (kitty, tmux, nvim — all **Tokyo Night**). It is launched
by typing `y` from any directory; the shell `cd`s to yazi's last
directory on exit.

What you get out of the box:

- **3-pane layout** (parent / current / preview) with the current pane
  highlighted in green, preview pane in blue.
- **Image previews** in the terminal via kitty's graphics protocol
  (works through tmux thanks to the existing `terminal-features` line).
- **Code previews** with proper syntax highlighting using the bundled
  `tokyo-night.tmTheme` (synced from folke/tokyonight.nvim).
- **Git status indicators** in the file list via the
  `yazi-rs/plugins:git` plugin. Colors mirror nvim's gitsigns +
  nvim-tree palette: `?` untracked (green), `+` added (green),
  `M` modified (yellow), `✗` deleted (red).
- **File-type colors**: directories blue, executables green, images
  yellow, videos/audio purple, archives orange, symlinks cyan, broken
  symlinks red.
- **Quick navigation**: `g h` home, `g c` nix config, `g d` Downloads,
  `g p` Projects, `g D` Desktop, `Ctrl+H` toggle hidden, `Ctrl+O` open
  with default app.
- **Custom linemode**: right side of each row shows file size and
  modified time (e.g. `2.3K May 12 14:33`).

Press `?` inside yazi for the full default keymap, and `q` to quit.

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
│   ├── yazi.nix              # Yazi configuration
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
│   ├── yazi/                  # Yazi configuration
│   │   ├── yazi.toml          #   General config (ratio, sort, openers)
│   │   ├── theme.toml         #   Tokyo Night color theme
│   │   ├── keymap.toml        #   Keybinding additions
│   │   ├── init.lua           #   Custom Linemode + plugin setup
│   │   └── themes/
│   │       └── tokyo-night.tmTheme  # Syntect theme for code previews
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
- If yazi image previews don't show through tmux, ensure your tmux is
  `>= 3.4` and that `terminal-features "xterm-256color:RGB"` is set
  (it already is in `configs/tmux.conf`).

