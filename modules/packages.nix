{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Shell plugins
    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-syntax-highlighting

    # Rust toolchain
    rustup

    # Editors
    neovim

    # CLI Tools
    ripgrep # Better grep
    fd # Better find
    git # Version control
    lazygit # Git TUI
    tree-sitter
    jq # JSON processor
    direnv # Per-directory environments
    nix-direnv # Faster direnv with Nix

    # Package managers & runtimes
    bun # Fast JavaScript runtime & package manager
    pnpm

    # Development tools
    go
    docker-compose
    gh # github cli

    # Static site generator
    hugo
  ];
}
