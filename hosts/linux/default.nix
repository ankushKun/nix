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

  # Linux-specific packages (if any)
  home.packages = with pkgs; [
    # Add any Linux-specific tools here
  ];
}
