{
  description = "Lorenzo Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, ... }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [
          mkalias
	  neovim
	  tmux
	  gh

	  kitty
	  obsidian
        ];

      homebrew = {
	enable = true;
	brews = [
	  "mas"
	];
	casks = [
	  "firefox"
	  "iina"
	  "the-unarchiver"
	];
	masApps = {};
	onActivation = {
	  cleanup = "zap";
	  autoUpdate = true;
	  upgrade = true;
	};
      };

      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      system = {
        activationScripts.applications.text = let
		env = pkgs.buildEnv {
		  name = "system-applications";
		  paths = config.environment.systemPackages;
		  pathsToLink = "/Applications";
		};
	      in
		pkgs.lib.mkForce ''
		# Set up applications.
		echo "setting up /Applications..." >&2
		rm -rf /Applications/Nix\ Apps
		mkdir -p /Applications/Nix\ Apps
		find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
		while read src; do
		  app_name=$(basename "$src")
		  echo "copying $src" >&2
		  ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
		done
		    '';
        defaults = {
	  dock = {
	    autohide = true;
	    persistent-apps = [
	      "${pkgs.kitty}/Applications/Kitty.app"
	      "/Applications/Firefox.app"
	      "${pkgs.obsidian}/Applications/Obsidian.app"
	    ];
	    tilesize = 48;
	  };
	  finder = {
	    _FXSortFoldersFirst = true;
	    # Search in current folder
	    FXDefaultSearchScope = "SCcf";
	    FXEnableExtensionChangeWarning = false;
	    # Show column style as default
	    FXPreferredViewStyle = "clmv";
	    # Allow quitting the Finder
	    QuitMenuItem = true;
	  };
	  # Disable quarantine for downloaded applications
	  LaunchServices.LSQuarantine = false;
	  loginwindow.GuestEnabled = false;
	  menuExtraClock = {
	    IsAnalog = true;
	    # Never show date
	    ShowDate = 2;
	  };
	  NSGlobalDomain = {
	    "com.apple.swipescrolldirection" = false;
	    # Enables swiping left or right with two fingers to navigate backward or forward
	    AppleEnableMouseSwipeNavigateWithScrolls = true;
	    AppleEnableSwipeNavigateWithScrolls = true;
	    AppleICUForce24HourTime = true;
	    InitialKeyRepeat = 20;
	    KeyRepeat = 1;
	    NSAutomaticCapitalizationEnabled = false;
	    NSAutomaticDashSubstitutionEnabled = false;
	    NSAutomaticInlinePredictionEnabled = false;
	    NSAutomaticPeriodSubstitutionEnabled = false;
	    NSAutomaticQuoteSubstitutionEnabled = false;
	    NSAutomaticSpellingCorrectionEnabled = false;
	    NSDocumentSaveNewDocumentsToCloud = false;
	    NSNavPanelExpandedStateForSaveMode = true;
	    NSNavPanelExpandedStateForSaveMode2 = true;
	    PMPrintingExpandedStateForPrint = true;
	    PMPrintingExpandedStateForPrint2 = true;
	  };
	};	

	keyboard = {
	  enableKeyMapping = true;
	  swapLeftCtrlAndFn = true;
	};
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."lorenzo-mbp" = nix-darwin.lib.darwinSystem {
      modules = [
      	configuration
	nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "lorenzo";

            # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = inputs.homebrew-core;
              "homebrew/homebrew-cask" = inputs.homebrew-cask;
	      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."lorenzo-mbp".pkgs;
  };
}
