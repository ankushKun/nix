{ pkgs, config, ... }:

{
  imports = [
    ./git.nix
    ./neovim.nix
    ./packages.nix
    ./shell.nix
    ./yazi.nix
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
    JAVA_HOME = "/Applications/Android Studio.app/Contents/jbr/Contents/Home";
    ANDROID_HOME = "$HOME/Library/Android/sdk";
    ANDROID_SDK_ROOT = "$HOME/Library/Android/sdk";
    CPPFLAGS = "-I/opt/homebrew/opt/openjdk/include";
    PNPM_HOME = "$HOME/.local/share/pnpm";
  };

  # PATH entries (consolidated from zshrc files)
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.local/bin"
    "/usr/local/sbin"
    "/opt/homebrew/bin"
    "/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin"
    "/opt/homebrew/opt/openjdk/bin"
    "/opt/homebrew/opt/openjdk@17/bin"
    "$ANDROID_HOME/platform-tools"
    "$ANDROID_HOME/emulator"
    "$ANDROID_HOME/cmdline-tools/latest/bin"
    "/usr/local/share/dotnet"
    "$HOME/.opencode/bin"
    "/Users/weeblet/.bun/bin"
    "$HOME/.local/share/solana/install/active_release/bin"
    "$HOME/.antigravity/antigravity/bin"
    "$PNPM_HOME"
  ];
}
