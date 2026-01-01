{ pkgs, ... }:

let
  packages = import ./packages.nix { inherit pkgs; };
in
{
  # Import Darwin-specific system configuration
  imports = [
    ./darwin/system.nix
  ];

  # Primary user for user-specific defaults
  system.primaryUser = "weeblet";

  # Allow unfree and impure packages
  nixpkgs.config = {
    allowUnfree = true;
    allowInsecure = true;
    allowUnsupportedSystem = true;
  };

  # System packages (GUI apps and macOS-specific tools)
  environment.systemPackages = packages.systemPackages;
}
