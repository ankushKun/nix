{ pkgs, ... }:

let
  packages = import ./packages.nix { inherit pkgs; };
in
{
  # Primary user for user-specific defaults
  system.primaryUser = "weeblet";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = packages.systemPackages;

  # Fonts configuration
  fonts.packages = [
    pkgs.meslo-lgs-nf
  ];

  # Nix settings
  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "weeblet" "@admin" ];
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 7;
      Hour = 3;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };

  # macOS system defaults
  system.defaults = {
    # Dock settings
    dock = {
      autohide = true;
      show-recents = false;
      minimize-to-application = true;
      persistent-apps = [
        "${pkgs.brave}/Applications/Brave Browser.app"
        "${pkgs.vscode}/Applications/Visual Studio Code.app"
        "${pkgs.kitty}/Applications/Kitty.app"
        "${pkgs.discord}/Applications/Discord.app"
      ];
    };

    # Finder settings
    finder = {
      FXPreferredViewStyle = "clmv";
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    # Custom user preferences
    CustomUserPreferences = {
      "com.apple.finder" = {
        # Finder sidebar favorites
        FXPreferredGroupBy = "Kind";
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
      };
      "com.apple.sidebarlists" = {
        # Sidebar favorites configuration
        systemitems = {
          ShowEjectables = true;
          ShowHardDisks = true;
          ShowRemovable = true;
          ShowServers = true;
        };
      };
    };

    # Login window settings
    loginwindow = {
      GuestEnabled = false;
    };

    # Screenshot location
    screencapture = {
      location = "~/Pictures/screenshots";
    };

    # Global domain settings
    NSGlobalDomain = {
      AppleICUForce24HourTime = false;
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.swipescrolldirection" = false;
      "com.apple.sound.beep.volume" = 0.7788008;
    };

    # Trackpad settings
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
  };

  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Used for backwards compatibility
  system.stateVersion = 6;
}
