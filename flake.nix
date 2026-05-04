{
  description = "Avie's NixOS Flake";

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    ...
  } @ inputs: let
    systems = [
      "aarch64-linux"
      "x88_64-linux"
    ];
    forAllSystems = inputs.nixpkgs.lib.genAttrs systems;

    pkgsFor = system:
      import nixpkgs {
        system = system;
        config = {
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };
        overlays = [
          inputs.apple-silicon.overlays.default
          inputs.nix-vscode-extensions.overlays.default
          inputs.firefox-addons.overlays.default
          inputs.niri.overlays.niri
          (import ./packages/overlay.nix)
          (import ./scripts/overlay.nix)
          (import ./overlay-arm64ec.nix)
          (final: prev: {
            x86 = import inputs.nixpkgs {
              system = "x86_64-linux";
              config.allowUnfree = true;
              config.allowUnsupportedSystem = true;
            };
          })
          (final: prev: {
            x86_stable = import inputs.nixpkgs-stable {
              system = "x86_64-linux";
              config.allowUnfree = true;
              config.allowUnsupportedSystem = true;
              config.permittedInsecurePackages = [
                "adobe-reader-9.5.5"
              ];
            };
          })
          (final: prev: {
            steam-pkgs = import inputs.steam-nixpkgs {
              system = "aarch64-linux";
              config.allowUnfree = true;
            };
          })
          (final: prev: {
            avie-pkgs = import inputs.nixpkgs-avie {
              system = "aarch64-linux";
              config.allowUnfree = true;
            };
          })
        ];
      };

    pkgsStableFor = system:
      import nixpkgs-stable {
        system = system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          inputs.apple-silicon.overlays.default
          inputs.nix-vscode-extensions.overlays.default
          inputs.firefox-addons.overlays.default
          inputs.niri.overlays.niri
          (import ./packages/overlay.nix)
          (import ./scripts/overlay.nix)
          (final: prev: {
            x86 = import nixpkgs-stable {
              system = "x86_64-linux";
              config.allowUnfree = true;
              config.allowUnsupportedSystem = true;
            };
          })
          (final: prev: {
            steam-pkgs = import inputs.steam-nixpkgs {
              system = "aarch64-linux";
              config.allowUnfree = true;
            };
          })
        ];
      };

    genUserSettings = {
      systemArg,
      hostArg,
      profileArg ? "desktop",
      isIsoArg ? false,
      wmArg ? "hyprland",
      browserArg ? "firefox",
      hostnameArg,
      stable ? false,
    }: rec {
      system = systemArg;
      host = hostArg;
      profile = profileArg;
      isIso = isIsoArg;
      pkgs =
        if stable
        then pkgsStableFor system
        else pkgsFor system;
      username = "avie";
      name = "Avie";
      dotfilesDir = ./.;
      wm = wmArg;
      browser = browserArg;
      hostname = hostnameArg;
      term = "kitty";
      editor = {
        name = "nvim";
        spawn = term + " -e " + editor.name;
      };
      fileManager = {
        name = "thunar";
        # package = (pkgsFor system).xfce.thunar;
        spawn = fileManager.name;
      };
      menu = {
        name = "fuzzel";
        spawn = menu.name;
      };
      timeZone = "Europe/Amsterdam";
      kb_layout = "pl";
      font = {
        name = "Jetbrains Mono NF";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      theme = "uwunicorn";
      systemModule = (
        if !isIso
        then ./hosts/${host}
        else ./hosts/${host}/iso.nix
      );
      userModule = ./profiles/${profile}/home.nix;
    };

    nixosSystemFor = userSettings:
      nixpkgs.lib.nixosSystem {
        pkgs = userSettings.pkgs;
        modules =
          [
            (userSettings.systemModule)
            inputs.niri.nixosModules.niri
          ]
          ++ [inputs.home-manager.nixosModules.home-manager self.nixosModules.my-user];
        specialArgs = {
          inherit inputs userSettings self;
        };
      };
  in {
    nixosConfigurations = {
      avie-nixos = nixosSystemFor (genUserSettings {
        systemArg = "aarch64-linux";
        hostArg = "asahi";
        hostnameArg = "avie-nixos";
        wmArg = "niri";
      });

      artemis-nixos = nixosSystemFor (genUserSettings {
        systemArg = "x86_64-linux";
        hostArg = "artemis";
        hostnameArg = "artemis-nixos";
        wmArg = "niri";
      });

      msi-nixos-server = nixosSystemFor (genUserSettings {
        systemArg = "x86_64-linux";
        hostArg = "msi";
        profileArg = "server";
        hostnameArg = "msi-nixos-server";
      });

      homelab-nixos = nixosSystemFor (genUserSettings {
        systemArg = "x86_64-linux";
        hostArg = "homelab";
        profileArg = "server";
        hostnameArg = "homelab-nixos";
        # stable = true;
        # wmArg = "none";
      });

      msi-nixos = nixosSystemFor (genUserSettings {
        systemArg = "x86_64-linux";
        hostArg = "msi";
        hostnameArg = "msi-nixos";
      });

      wsl-nixos = nixosSystemFor (genUserSettings {
        systemArg = "x86_64-linux";
        hostArg = "wsl";
        hostnameArg = "wsl-nixos";
        profileArg = "wsl";
        wmArg = "none";
        browserArg = "none";
      });

      vps = nixosSystemFor (genUserSettings {
        systemArg = "x86_64-linux";
        hostArg = "vps";
        profileArg = "server";
      });
    };

    nixosModules = {
      my-user = {userSettings, ...}: {
        home-manager = {
          backupFileExtension = "backup3";
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${userSettings.username} = userSettings.userModule;
          extraSpecialArgs = {
            inherit userSettings inputs;
          };
          sharedModules = [
            inputs.nix-index-database.homeModules.nix-index
            # inputs.stylix.homeModules.stylix
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

            android_sdk.accept_license = true;
          };
          overlays = [
            inputs.apple-silicon.overlays.default
            inputs.nix-vscode-extensions.overlays.default
            inputs.firefox-addons.overlays.default
            (import ./packages/overlay.nix)
            (import ./scripts/overlay.nix)
          ];
        };
        userSettings = genUserSettings {
          systemArg = "aarch64-linux";
          hostArg = "asahi";
          hostnameArg = "avie-nixos";
          profileArg = "installer";
          isIsoArg = true;
          wmArg = "none";
        };
      in {
        wine-arm64ec = (pkgsFor system).callPackage ./wine-arm64ec.nix {};
        inherit
          (pkgs)
          m1n1
          uboot-asahi
          linux-asahi
          asahi-fwextract
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
              ./hosts/asahi/iso.nix
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

    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      baigiel = pkgs.mkShell {
        packages = with pkgs; [
          nodejs_22
        ];
      };
    });
  };

  inputs = {
    steam-nixpkgs.url = "github:dramforever/nixpkgs/muvm-steam-less-hacks";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-24.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-avie.url = "github:Avie238/nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
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

    flake-compat.url = "github:nix-community/flake-compat";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    niri.url = "github:sodiboo/niri-flake";
  };

  nixConfig = {
    extra-substituters = [
      "https://nixos-apple-silicon.cachix.org"
      "https://hyprland.cachix.org"
      "https://niri.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };
}
