{
  description = "Avie's NixOS Flake";

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    forAllSystems = inputs.nixpkgs.lib.genAttrs systems;

    pkgsFor = system:
      import nixpkgs {
        system = system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          inputs.apple-silicon.overlays.default
          inputs.nix-vscode-extensions.overlays.default
          inputs.firefox-addons.overlays.default
          inputs.nur.overlays.default
        ];
      };

    genUserSettings = {
      system_type,
      selectedProfile,
      iso,
      windowManager ? "hyprland",
    }: rec {
      system = system_type;
      profile = selectedProfile;
      isIso = iso;
      username = "avie";
      name = "Avie";
      dotfilesDir = ./.;
      wm = windowManager;
      browser = "firefox";
      term = "kitty";
      editor = "codium";
      fileManager = "thunar";
      menu = "rofi";
      menu_spawn = "${menu} -show drun -show-icons -run-command \"uwsm app -- {cmd}\"";
      timeZone = "Europe/Amsterdam";
      kb_layout = "pl";
      font = "Jetbrains Mono NF";
      fontPkg = "jetbrains-mono";
      theme = "uwunicorn"; # "tokyo-night-terminal-dark"; # "stella"; # "selenized-black"; # "pasque"; # "eris"; # "mellow-purple"; # "darkviolet";
    };
  in {
    nixosConfigurations = {
      avie-nixos = let
        userSettings = genUserSettings {
          system_type = "aarch64-linux";
          selectedProfile = "desktop";
          iso = false;
        };
      in
        nixpkgs.lib.nixosSystem {
          pkgs = pkgsFor userSettings.system;
          modules = [
            (
              if !userSettings.isIso
              then ./hosts/asahi
              else ./hosts/asahi/iso
            )
            inputs.home-manager.nixosModules.home-manager
            self.nixosModules.my-user
          ];
          specialArgs = {inherit inputs userSettings self;};
        };

      msi-nixos = let
        userSettings = genUserSettings {
          system_type = "x86_64-linux";
          selectedProfile = "dekstop";
          iso = false;
        };
      in
        nixpkgs.lib.nixosSystem {
          pkgs = pkgsFor userSettings.system;
          modules = [
            (
              if !userSettings.isIso
              then ./hosts/msi
              else ./hosts/msi/iso
            )
            inputs.home-manager.nixosModules.home-manager
            self.nixosModules.my-user
          ];
          specialArgs = {inherit inputs userSettings self;};
        };
    };

    nixosModules = {
      my-user = {userSettings, ...}: {
        home-manager = {
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${userSettings.username} = {
            imports = [./profiles/${userSettings.profile}/home.nix];
          };
          extraSpecialArgs = {inherit userSettings;};
          sharedModules = [
            inputs.nixcord.homeManagerModules.nixcord
            inputs.nix-index-database.hmModules.nix-index
            inputs.nvf.homeManagerModules.default
          ];
        };
      };
    };

    packages = forAllSystems (
      system: let
        pkgs = import inputs.nixpkgs {
          crossSystem.system = "aarch64-linux";
          localSystem.system = system;
          config = {
            allowUnfree = true;
          };
          overlays = [
            (import inputs.rust-overlay)
            inputs.apple-silicon.overlays.default
            inputs.nix-vscode-extensions.overlays.default
            inputs.firefox-addons.overlays.default
            inputs.nur.overlays.default
          ];
        };
        userSettings = genUserSettings {
          system_type = "aarch64-linux";
          selectedProfile = "recovery";
          iso = true;
          windowManager = "gnome";
        };
      in {
        inherit
          (pkgs)
          m1n1
          uboot-asahi
          linux-asahi
          asahi-fwextract
          mesa-asahi-edge
          ;
        inherit (pkgs) asahi-audio;

        installer-bootstrap = let
          installer-system = inputs.nixpkgs.lib.nixosSystem {
            inherit system;

            pkgs = import inputs.nixpkgs {
              crossSystem.system = "aarch64-linux";
              localSystem.system = system;
              config = {
                allowUnfree = true;
              };
              overlays = [
                inputs.apple-silicon.overlays.default
                inputs.nix-vscode-extensions.overlays.default
                inputs.firefox-addons.overlays.default
                inputs.nur.overlays.default
              ];
            };
            specialArgs = {
              modulesPath = inputs.nixpkgs + "/nixos/modules";
              inputs = inputs;
              userSettings = userSettings;
            };

            modules = [
              ./hosts/asahi/iso
              (inputs.apple-silicon + "/iso-configuration")
              {hardware.asahi.pkgsSystem = system;}
              inputs.home-manager.nixosModules.home-manager
              self.nixosModules.my-user
            ];
          };

          config = installer-system.config;
        in (config.system.build.isoImage.overrideAttrs (old: {
          # add ability to access the whole config from the command line
          passthru =
            (old.passthru or {})
            // {
              inherit config;
            };
        }));
      }
    );
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    apple-silicon = {
      url = "github:Avie238/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      flake = false;
    };

    flake-compat.url = "github:nix-community/flake-compat";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
