{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Shell plugins
    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-syntax-highlighting

    # Rust toolchain (using rustup for cross-platform compatibility)
    rustup

    # Editors
    neovim

    # Language servers
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    lua-language-server
    pyright
    gopls
    nil # Nix LSP

    # CLI Tools
    home-manager # Home Manager CLI
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

    # Package managers & runtimes
    nodejs     # Node.js runtime (includes npm)
    yarn       # Alternative npm client
    bun        # Fast JavaScript runtime & package manager
    pnpm       # Fast, disk space efficient package manager

    # Development tools
    go
    docker-compose

    # Static site generator
    hugo
  ];
}
