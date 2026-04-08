{ config, ... }:

{
  # Neovim configuration
  home.file.".config/nvim/init.lua".source = ../configs/nvim-init.lua;
}
