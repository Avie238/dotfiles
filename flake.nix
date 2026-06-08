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
      "x86_64-linux"
    ];
    forAllSystems = inputs.nixpkgs.lib.genAttrs systems;

    overlays = [
      inputs.apple-silicon.overlays.default
      inputs.nix-vscode-extensions.overlays.default
      inputs.firefox-addons.overlays.default
      inputs.niri.overlays.niri
      (import ./packages/overlay.nix)
      (import ./scripts/overlay.nix)
      (final: prev: {
        x86 = import inputs.nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          config.allowUnsupportedSystem = true;
        };
      })
    ];

    nix_config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };

    pkgsFor = system:
      import nixpkgs {
        config = nix_config;
        inherit system overlays;
      };

    pkgsStableFor = system:
      import nixpkgs-stable {
        config = nix_config;
        inherit system overlays;
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
        modules = [
          (userSettings.systemModule)
          inputs.niri.nixosModules.niri
          self.nixosModules.my-user
          (
            if userSettings.stable
            then inputs.home-manager-stable.nixosModules.home-manager
            else inputs.home-manager.nixosModules.home-manager
          )
        ];
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

      homelab-nixos = nixosSystemFor (genUserSettings {
        systemArg = "x86_64-linux";
        hostArg = "homelab";
        profileArg = "server";
        hostnameArg = "homelab-nixos";
        stable = true;
        wmArg = "none";
      });

      homelab-iso = nixosSystemFor (genUserSettings {
        systemArg = "x86_64-linux";
        hostArg = "homelab";
        profileArg = "server";
        hostnameArg = "homelab-nixos";
        stable = true;
        wmArg = "none";
        isIsoArg = true;
      });

      wsl-nixos = nixosSystemFor (genUserSettings {
        systemArg = "x86_64-linux";
        hostArg = "wsl";
        hostnameArg = "wsl-nixos";
        profileArg = "wsl";
        stable = true;
        wmArg = "none";
      });
    };

    nixosModules = {
      my-user = {userSettings, ...}: {
        home-manager = {
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${userSettings.username} = userSettings.userModule;
          extraSpecialArgs = {
            inherit userSettings inputs;
          };
          sharedModules = [
            inputs.nix-index-database.homeModules.nix-index
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
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-avie.url = "github:Avie238/nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-26.05";
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
    extra-trusted-substituters = [
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
