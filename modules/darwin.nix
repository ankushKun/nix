{ pkgs, ... }:

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

  # System packages
  environment.systemPackages = [
    pkgs.meslo-lgs-nf
  ];
}
