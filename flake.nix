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
      # $ darwin-rebuild switch --flake .#weeblets-mbp
      darwinConfigurations."weeblets-mbp" = nix-darwin.lib.darwinSystem {
        modules = [
          # Configure nixpkgs with unfree packages allowed
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.allowInsecure = true;
            nixpkgs.config.allowUnsupportedSystem = true;
          }

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

      # Standalone Home Manager for Linux systems
      # Usage: home-manager switch --flake .#username@hostname
      homeConfigurations = {
        # Example: "user@hostname" - update to match your Linux username and hostname
        # After cloning on your Linux system, run:
        # nix run home-manager/master -- switch --flake ~/.config/nix#username@hostname
        "username@hostname" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          modules = [ ./hosts/linux/default.nix ];
        };
      };

      # Formatters for 'nix fmt'
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
