{ pkgs, lib, ... }:

let
  # Automatically detect username from environment
  username = builtins.getEnv "USER";
in
{
  # Import common cross-platform configuration
  imports = [
    ../../modules/common/home.nix
  ];

  # User information (automatically detected from $USER environment variable)
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Linux-specific packages
  home.packages = with pkgs; [
    # home-manager command for standalone installations
    home-manager
  ];
}
