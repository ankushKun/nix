{ pkgs, lib, ... }:
{
  # Yazi terminal file explorer, themed to match the rest of the
  # terminal apps (kitty, tmux, nvim — all Tokyo Night).
  #
  # Color theme lives in `configs/yazi/theme.toml`, general config in
  # `configs/yazi/yazi.toml`, keymap additions in `configs/yazi/keymap.toml`,
  # and a custom `size_and_mtime` Linemode in `configs/yazi/init.lua`.
  #
  # The code-preview highlighter (syntect) uses `Tokyo Night Night`
  # — synced from folke/tokyonight.nvim into
  # `configs/yazi/themes/tokyo-night.tmTheme`.

  programs.yazi = {
    enable = true;
    package = pkgs.yazi;

    # Type `y` from the shell to launch yazi in $PWD; on exit, the
    # shell cds into the last directory yazi was in.
    shellWrapperName = "y";
    enableZshIntegration = true;

    # Make preview helpers available to yazi's wrapper script:
    #   git                → required by yazi-rs/plugins:git
    #   ffmpegthumbnailer  → video thumbnails
    #   poppler-utils      → PDF rendering (pdftoppm)
    #   p7zip              → archive listing / extraction
    #   jq                 → JSON pretty-printing in preview
    #   unar               → archive extraction opener
    extraPackages = with pkgs; [
      git
      ffmpegthumbnailer
      poppler-utils
      p7zip
      jq
      unar
    ];

    settings = lib.importTOML ../configs/yazi/yazi.toml;
    theme = lib.importTOML ../configs/yazi/theme.toml;
    keymap = lib.importTOML ../configs/yazi/keymap.toml;
    initLua = ../configs/yazi/init.lua;

    # Git status indicators in the file list. The plugin is linked
    # to ~/.config/yazi/plugins/git.yazi and `require("git"):setup()`
    # is called from init.lua. Also wired up as a fetcher in
    # yazi.toml's `plugin.prepend_fetchers` block.
    plugins.git = pkgs.yaziPlugins.git;
  };

  # Syntect theme used by yazi's code previewer. Not handled by the
  # home-manager module, so symlink it manually.
  xdg.configFile."yazi/themes/tokyo-night.tmTheme".source =
    ../configs/yazi/themes/tokyo-night.tmTheme;
}
