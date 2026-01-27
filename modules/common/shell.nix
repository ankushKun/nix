{ pkgs, lib, config, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  # Zsh configuration with Oh My Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    
    # Completion caching for faster startup
    completionInit = "autoload -U compinit && compinit -C";

    # Oh My Zsh - minimal plugins for faster startup
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      # Custom settings for performance
      custom = "";
    };

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

    # Load custom zshrc (platform-specific) + optimizations + PATH additions
    initContent = lib.mkMerge [
      # Performance optimizations (loaded early)
      (lib.mkOrder 550 ''
        # Reduce plugin overhead
        ZSH_AUTOSUGGEST_MANUAL_REBIND=1
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
      '')
      
      # Main configuration
      (builtins.readFile ../../configs/shared/zshrc +
       (if isDarwin then builtins.readFile ../../configs/darwin/zshrc-darwin else "") +
       (lib.optionalString isDarwin ''
         export PATH="/usr/local/share/dotnet:$PATH"
         export PATH="$HOME/.opencode/bin:$PATH"
       '') +
       (lib.optionalString isLinux ''
         export PATH="$HOME/.bun/bin:$PATH"
         
         # NVM setup
         export NVM_DIR="$HOME/.nvm"
         [ -s "${pkgs.nvm}/nvm.sh" ] && . "${pkgs.nvm}/nvm.sh"
         [ -s "${pkgs.nvm}/bash_completion" ] && . "${pkgs.nvm}/bash_completion"
       ''))
    ];

    # Shell aliases - modern alternatives
    shellAliases = {
      # Better ls (eza)
      ls = "eza --icons --group-directories-first";
      ll = "eza --icons --group-directories-first -l";
      la = "eza --icons --group-directories-first -la";
      lt = "eza --icons --group-directories-first --tree";
      l = "eza --icons --group-directories-first -lah";

      # Better cat (bat)
      cat = "bat --style=auto";

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
    } // lib.optionalAttrs isDarwin {
      # Darwin-specific aliases
      dr = "sudo darwin-rebuild switch --flake ~/.config/nix#weeblets-mbp";
      hmr = "home-manager switch --flake ~/.config/nix#weeblets-mbp";
      nix-config = "nvim ~/.config/nix/flake.nix";
      icloud = "cd ~/Library/Mobile\\ Documents/com~apple~CloudDocs";
    } // lib.optionalAttrs isLinux {
      # Linux-specific aliases
      hm = "home-manager switch --flake ~/.config/nix#linux --impure";
    };
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
    extraConfig = builtins.readFile ../../configs/shared/tmux.conf;
  };

  # Link Powerlevel10k config
  home.file.".p10k.zsh".source = ../../configs/shared/p10k.zsh;
}
