{ pkgs, ... }:

{
  # Import common cross-platform configuration
  imports = [
    ../../modules/common/home.nix
  ];

  # User information (update these for your Linux system)
  home.username = "YOUR_LINUX_USERNAME";  # Change this to your username
  home.homeDirectory = "/home/YOUR_LINUX_USERNAME";  # Change this to match your username

  # Linux-specific packages (if any)
  home.packages = with pkgs; [
    # Add any Linux-specific tools here
  ];
}
