{ pkgs, ... }:

{
  # Import common cross-platform configuration
  imports = [
    ../../modules/common/home.nix
  ];

  # User information (update these for your VPS)
  home.username = "YOUR_VPS_USERNAME";  # Change this to your VPS username
  home.homeDirectory = "/home/YOUR_VPS_USERNAME";  # Change this to match your username

  # VPS-specific packages (if any)
  home.packages = with pkgs; [
    # Add any VPS-only tools here
  ];
}
