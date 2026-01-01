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
    EDITOR = "${pkgs.neovim}/bin/nvim";
    VISUAL = "${pkgs.neovim}/bin/nvim";
  };
}
