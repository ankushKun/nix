{ pkgs, ... }:

{
  # System-wide packages (installed at the system level)
  systemPackages = [
    pkgs.kitty
    # pkgs.vscode
    pkgs.rectangle
    # pkgs.mas  # Mac App Store CLI
    pkgs.meslo-lgs-nf
  ];

  # User packages (installed via Home Manager)
  userPackages = with pkgs; [
    # Shell plugins
    zsh-powerlevel10k

    # Rust toolchain (consider using rustup for better version management)
    rustup

    # Editors
    neovim

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

    # Package managers & runtimes
    bun        # Fast JavaScript runtime & package manager

    go
    docker
    docker-compose
    colima

    hugo
  ];
}
