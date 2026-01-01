{ pkgs, config, ... }:

{
  # Import common cross-platform configuration
  imports = [
    ./common/home.nix
    ./darwin/gui.nix
  ];
}
