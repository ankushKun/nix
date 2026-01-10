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

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
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

    # Load custom zshrc (platform-specific)
    initContent =
      builtins.readFile ../../configs/shared/zshrc +
      (if isDarwin then builtins.readFile ../../configs/darwin/zshrc-darwin else "");

    # Platform-specific PATH additions
    initExtra = lib.optionalString isDarwin ''
      export PATH="/usr/local/share/dotnet:$PATH"
      export PATH="$HOME/.opencode/bin:$PATH"
    '' + lib.optionalString isLinux ''
      export PATH="$HOME/.bun/bin:$PATH"
    '';

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

  # Direnv integration
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Tmux configuration
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ../../configs/shared/tmux.conf;
  };

  # Link Powerlevel10k config
  home.file.".p10k.zsh".source = ../../configs/shared/p10k.zsh;
}
