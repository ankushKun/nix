{ pkgs, ... }:

{
  # GUI application packages
  home.packages = with pkgs; [
    claude-code
    kitty
    discord
    rectangle
    neovide  # Neovim GUI client
    # Add docker/colima for macOS
    docker
    colima
  ];

  # Kitty configuration
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    settings = {
      shell = "${pkgs.zsh}/bin/zsh --login --interactive -c '${pkgs.tmux}/bin/tmux'";
    };
    extraConfig = builtins.readFile ../../configs/darwin/kitty.conf;
  };

  # Rectangle configuration
  home.file."Library/Application Support/Rectangle/RectangleConfig.json".source = ../../configs/darwin/rectangle.json;

  # Neovide configuration
  home.file.".config/neovide/config.toml".source = ../../configs/darwin/neovide.toml;
}
