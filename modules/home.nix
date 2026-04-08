{ pkgs, config, ... }:

{
  imports = [
    ./git.nix
    ./neovim.nix
    ./packages.nix
    ./shell.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home.stateVersion = "24.05";

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    LANG = "en_US.UTF-8";
    NIXPKGS_ALLOW_UNFREE = "1";
    HOMEBREW_NO_AUTO_UPDATE = "1";
    CPPFLAGS = "-I/opt/homebrew/opt/openjdk/include";
  };

  # PATH entries (consolidated from zshrc files)
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.local/bin"
    "/usr/local/sbin"
    "/opt/homebrew/bin"
    "/opt/homebrew/opt/openjdk/bin"
    "/opt/homebrew/opt/openjdk@17/bin"
    "/usr/local/share/dotnet"
    "$HOME/.opencode/bin"
    "/Users/weeblet/.bun/bin"
    "$HOME/.local/share/solana/install/active_release/bin"
    "$HOME/.antigravity/antigravity/bin"
  ];
}
