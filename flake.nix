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
          (import ./packages/overlay.nix)
          (import ./scripts/overlay.nix)
          inputs.nixos-mmuvm-fex.overlays.default
        ];
      };

    genUserSettings = {
      systemArg,
      hostArg,
      profileArg ? "desktop",
      isIsoArg ? false,
      wmArg ? "hyprland",
    }: rec {
      system = systemArg;
      host = hostArg;
      profile = profileArg;
      isIso = isIsoArg;
      username = "avie";
      name = "Avie";
      dotfilesDir = ./.;
      wm = wmArg;
      browser = "firefox";
      term = "kitty";
      editor = {
        name = "nvim";
        spawn = term + " -e " + editor.name;
      };
      fileManager = {
        name = "ranger";
        package = (pkgsFor system).ranger;
        spawn = term + " -e " + fileManager.name;
      };
      menu = {
        name = "rofi";
        spawn = "${menu.name} -show drun -show-icons -run-command \"uwsm app -- {cmd}\"";
      };
      timeZone = "Europe/Amsterdam";
      kb_layout = "pl";
      font = {
        name = "Jetbrains Mono NF";
        package = (pkgsFor system).nerd-fonts.jetbrains-mono;
      };
      theme = "uwunicorn"; # "tokyo-night-terminal-dark"; # "stella"; # "selenized-black"; # "pasque"; # "eris"; # "mellow-purple"; # "darkviolet";
    };

    nixosSystemFor = userSettings:
      nixpkgs.lib.nixosSystem {
        pkgs = pkgsFor userSettings.system;
        modules = [
          (
            if !userSettings.isIso
            then ./hosts/${userSettings.host}
            else ./hosts/${userSettings.host}/iso
          )
          inputs.home-manager.nixosModules.home-manager
          self.nixosModules.my-user
        ];
        specialArgs = {inherit inputs userSettings self;};
      };
  in {
    nixosConfigurations = {
      avie-nixos = nixosSystemFor (genUserSettings {
        systemArg = "aarch64-linux";
        hostArg = "asahi";
      });

      msi-nixos = nixosSystemFor (genUserSettings {
        systemArg = "x86_64-linux";
        hostArg = "msi";
      });

      msi-nixos-live = nixosSystemFor (genUserSettings {
        systemArg = "x86_64-linux";
        hostArg = "msi";
        isIsoArg = true;
      });
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
          extraSpecialArgs = {inherit userSettings inputs;};
          sharedModules = [
            inputs.nixcord.homeModules.nixcord
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
            inputs.apple-silicon.overlays.default
            inputs.nix-vscode-extensions.overlays.default
            inputs.firefox-addons.overlays.default
            inputs.nur.overlays.default
            (import ./packages/overlay.nix)
            (import ./scripts/overlay.nix)
          ];
        };
        userSettings = genUserSettings {
          systemArg = "aarch64-linux";
          hostArg = "asahi";
          profileArg = "installer";
          isIsoArg = true;
          wmArg = "none";
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
                (import ./packages/overlay.nix)
                (import ./scripts/overlay.nix)
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
      # url = "github:Avie238/nixos-apple-silicon";
      # url = "github:flokli/nixos-apple-silicon/wip";
      url = "github:yuyuyureka/nixos-apple-silicon/minimize-patches";
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
    nixos-mmuvm-fex.url = "github:nrabulinski/nixos-muvm-fex";
  };
}
