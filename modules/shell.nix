{ pkgs, lib, config, ... }:

{
  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # Completion caching for faster startup
    completionInit = "autoload -U compinit && compinit -C";

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-autosuggestions";
        src = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
        file = "zsh-autosuggestions.zsh";
      }
      # Syntax highlighting should be loaded last for performance
      {
        name = "zsh-syntax-highlighting";
        src = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.zsh";
      }
    ];

    # Shell history configuration
    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      ignoreDups = true;
      share = true;
    };

    # Load custom zshrc
    initContent = lib.mkMerge [
      # Performance optimizations (loaded early)
      (lib.mkOrder 550 ''
        # Reduce plugin overhead
        ZSH_AUTOSUGGEST_MANUAL_REBIND=1
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
      '')

      # Main configuration (p10k, ascii art, nvm lazy-loading)
      (builtins.readFile ../configs/zshrc)
    ];

    # Shell aliases
    shellAliases = {
      # Better grep (ripgrep)
      grep = "rg";

      # Better find (fd)
      find = "fd";

      # Git aliases
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      lg = "lazygit";

      # Editor aliases
      sv = "sudo nvim";
      zshconfig = "nvim ~/.zshrc";

      # Kitty aliases
      sshk = "kitty +kitten ssh";
      kittyw = "kitty -o hide_window_decorations=no -o background_opacity=1.0";

      # Darwin aliases
      dr = "sudo darwin-rebuild switch --flake ~/.config/nix#weeblets-mbp";
      hmr = "home-manager switch --flake ~/.config/nix#weeblets-mbp";
      nix-config = "nvim ~/.config/nix/flake.nix";
      icloud = "cd ~/Library/Mobile\\ Documents/com~apple~CloudDocs";
    };
  };

  # Fzf with shell integration (Ctrl+R history, Ctrl+T file finder)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Bat (better cat)
  programs.bat = {
    enable = true;
    config.style = "auto";
  };

  # Eza (better ls)
  programs.eza = {
    enable = true;
    icons = "auto";
    extraOptions = [ "--group-directories-first" ];
  };

  # Direnv integration (optimized with caching)
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    config = {
      global = {
        # Reduce startup time by caching
        warn_timeout = "30s";
      };
    };
  };

  # Tmux configuration
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ../configs/tmux.conf;
  };

  # Link Powerlevel10k config
  home.file.".p10k.zsh".source = ../configs/p10k.zsh;
}
