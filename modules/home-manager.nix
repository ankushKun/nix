{ pkgs, config, ... }:

let
  packages = import ./packages.nix { inherit pkgs; };
in
{
  home.stateVersion = "24.05";

  # User packages
  home.packages = packages.userPackages;

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ankushKun";
        email = "ankush4singh@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

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

    # Load custom zshrc
    initContent = builtins.readFile ../configs/zshrc;

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

      # Nix Darwin aliases
      dr = "sudo darwin-rebuild switch --flake ~/.config/nix#weeblets-mbp";
      nix-config = "nvim /Users/$(whoami)/.config/nix/flake.nix";
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
    extraConfig = builtins.readFile ../configs/tmux.conf;
  };

  # Kitty configuration
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    settings = {
      shell = "${pkgs.zsh}/bin/zsh --login --interactive -c '${pkgs.tmux}/bin/tmux'";
    };
    extraConfig = builtins.readFile ../configs/kitty.conf;
  };

  # Link Powerlevel10k config
  home.file.".p10k.zsh".source = ../configs/p10k.zsh;

  # Neovim configuration
  home.file.".config/nvim/init.lua".source = ../configs/nvim-init.lua;

  # Rectangle configuration
  home.file."Library/Application Support/Rectangle/RectangleConfig.json".source = ../configs/rectangle.json;

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
