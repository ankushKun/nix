{ pkgs, ... }:

{
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

  # Homebrew configuration
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    # Mac App Store apps (requires mas)
    masApps = {
      # Add your Mac App Store apps here
      # Example: AppName = 1234567890;
    };
  };

  # macOS system defaults
  system.defaults = {
    # Dock settings
    dock = {
      autohide = true;
      show-recents = false;
      minimize-to-application = true;
    };

    # Finder settings
    finder = {
      FXPreferredViewStyle = "icnv";
      QuitMenuItem = true;
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
      # Disable autocorrect and auto-substitutions
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
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
