{ pkgs, ... }:

{
  # GUI application packages
  home.packages = with pkgs; [
    kitty
    # Docker for macOS
    docker
    colima
  ];

  # Kitty configuration
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    settings = {
      shell = "${pkgs.zsh}/bin/zsh --login --interactive -c '${pkgs.tmux}/bin/tmux'";
      font_family = "MesloLGS NF";
      bold_font = "MesloLGS NF Bold";
      italic_font = "MesloLGS NF Italic";
      bold_italic_font = "MesloLGS NF Bold Italic";
      font_size = 13;
      draw_minimal_borders = "yes";
      inactive_text_alpha = "0.8";
      hide_window_decorations = "yes";
      tab_fade = "0.5 1";
      background_opacity = "1.0";
      background_blur = 0;
      macos_window_resizable = "yes";
    };
    # Color scheme (Tokyo Night) loaded from file
    extraConfig = builtins.readFile ../../configs/darwin/kitty.conf;
  };

  # Rectangle configuration
  home.file."Library/Application Support/Rectangle/RectangleConfig.json".source = ../../configs/darwin/rectangle.json;
}
