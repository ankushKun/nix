{ pkgs, ... }:

{
  # Kitty configuration (app installed via Homebrew cask)
  home.file.".config/kitty/kitty.conf".text = ''
    shell ${pkgs.zsh}/bin/zsh --login --interactive -c '${pkgs.tmux}/bin/tmux'
    font_family MesloLGS NF
    bold_font MesloLGS NF Bold
    italic_font MesloLGS NF Italic
    bold_italic_font MesloLGS NF Bold Italic
    font_size 14
    draw_minimal_borders yes
    inactive_text_alpha 0.6
    hide_window_decorations yes
    tab_fade 0.5 1
    background_opacity 0.85
    background_blur 35
    macos_window_resizable yes
  '' + builtins.readFile ../../configs/darwin/kitty.conf;

  # Rectangle configuration
  home.file."Library/Application Support/Rectangle/RectangleConfig.json".source = ../../configs/darwin/rectangle.json;
}
