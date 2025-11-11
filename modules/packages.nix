{ pkgs, ... }:

{
  # System-wide packages (installed at the system level)
  systemPackages = [
    pkgs.claude-code
    pkgs.kitty
    pkgs.vscode
    pkgs.discord
    pkgs.brave
    pkgs.rectangle
    pkgs.meslo-lgs-nf
  ];

  # User packages (installed via Home Manager)
  userPackages = with pkgs; [
    # Shell plugins
    zsh-powerlevel10k

    # Rust toolchain (consider using rustup for better version management)
    rustup

    # Editors
    lunarvim # Pre-configured Neovim IDE
    neovim   # Simple/vanilla Neovim

    # Language servers
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    lua-language-server
    pyright
    # rust-analyzer is provided by rustup
    gopls
    nil # Nix LSP

    # CLI Tools
    ripgrep    # Better grep
    fd         # Better find
    git        # Version control
    fzf        # Fuzzy finder
    lazygit    # Git TUI
    tree-sitter
    jq         # JSON processor
    bat        # Better cat
    eza        # Better ls
    direnv     # Per-directory environments
    nix-direnv # Faster direnv with Nix

    # Package managers
    bun        # Fast JavaScript runtime & package manager
    pnpm       # Fast, disk space efficient package manager
  ];
}
