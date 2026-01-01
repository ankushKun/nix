{ config, ... }:

{
  # Neovim configuration
  home.file.".config/nvim/init.lua".source = ../../configs/shared/nvim-init.lua;
}
