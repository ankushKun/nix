{
  description = "Weeblet's Nix Darwin Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild switch --flake .#simple
      darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
        modules = [
          # Import darwin-specific configuration
          ./modules/darwin.nix

          # Set Git commit hash for darwin-version
          { system.configurationRevision = self.rev or self.dirtyRev or null; }

          # Home Manager module
          home-manager.darwinModules.home-manager
          {
            users.users.weeblet.home = "/Users/weeblet";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.weeblet = import ./modules/home-manager.nix;
          }
        ];
      };

      # Formatter for 'nix fmt'
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
    };
}
