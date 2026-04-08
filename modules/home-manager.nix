{ pkgs, config, ... }:

{
  # Import configuration modules
  imports = [
    ./home.nix
    ./darwin/gui.nix
  ];
}
