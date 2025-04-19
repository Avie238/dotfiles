{
  description = "Avie's NixOS Flake";

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = inputs.nixpkgs.lib.genAttrs systems;

      pkgsFor =
        system:
        import nixpkgs {
          system = system;
          config = {
            allowUnfree = true;
          };
          overlays = [
            inputs.apple-silicon.overlays.default
            inputs.nix-vscode-extensions.overlays.default
            inputs.firefox-addons.overlays.default
          ];
        };

      userSettings = rec {
        username = "avie";
        name = "Avie";
        dotfilesDir = "~/dotfiles";
        wm = "hyprland";
        browser = "firefox";
        term = "kitty";
        editor = "codium";
        fileManager = "thunar";
        menu = "rofi";
        menu_spawn = "${menu} -show drun -show-icons";
        timeZone = "Europe/Amsterdam";
        kb_layout = "pl";
        font = "Jetbrains Mono NF";
        fontPkg = "jetbrains-mono";
        theme = "uwunicorn"; # "tokyo-night-terminal-dark"; # "stella"; # "selenized-black"; # "pasque"; # "eris"; # "mellow-purple"; # "darkviolet";
      };

    in
    {
      nixosConfigurations = {
        avie-nixos = nixpkgs.lib.nixosSystem {
          pkgs = pkgsFor "aarch64-linux";
          modules = [
            ./hosts/asahi
            home-manager.nixosModules.home-manager
            self.nixosModules.my-user

          ];
          specialArgs = { inherit inputs userSettings self; };
        };

        # msi-nixos = nixpkgs.lib.nixosSystem {
        #   pkgs = pkgsFor "x86_64-linux";
        #   modules = [
        #     ./hosts/msi
        #     home-manager.nixosModules.home-manager
        #     self.nixosModules.users-avie
        #     inputs.disko.nixosModules.default
        #     inputs.impermanence.nixosModules.impermanence
        #   ];
        #   specialArgs = { inherit inputs userSettings self; };
        # };

        # msi-iso = nixpkgs.lib.nixosSystem {
        #   pkgs = pkgsFor "x86_64-linux";
        #   modules = [
        #     ./hosts/msi/iso
        #     home-manager.nixosModules.home-manager
        #     (self.nixosModules.users-avie { desktop = false; })
        #   ];
        #   specialArgs = { inherit inputs self; };
        # };

      };

      nixosModules = {

        my-user =
          {
            userSettings,
            ...
          }:
          {
            home-manager = {
              backupFileExtension = "backup";
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${userSettings.username} = {
                imports =
                  if userSettings.wm != "none" then [ ./profiles/minimal.nix ] else [ ./profiles/desktop.nix ];

              };
              extraSpecialArgs = { inherit userSettings; };
              sharedModules = [
                inputs.nixcord.homeManagerModules.nixcord
              ];
            };

          };

      };

      packages = forAllSystems (
        system:
        let
          pkgs = import inputs.nixpkgs {
            crossSystem.system = "aarch64-linux";
            localSystem.system = system;
            overlays = [
              (import inputs.rust-overlay)
              inputs.apple-silicon.overlays.default
              inputs.nix-vscode-extensions.overlays.default
            ];
          };
        in
        {
          inherit (pkgs)
            m1n1
            uboot-asahi
            linux-asahi
            asahi-fwextract
            mesa-asahi-edge
            ;
          inherit (pkgs) asahi-audio;

          installer-bootstrap =
            let
              installer-system = inputs.nixpkgs.lib.nixosSystem {
                inherit system;

                pkgs = import inputs.nixpkgs {
                  crossSystem.system = "aarch64-linux";
                  localSystem.system = system;
                  overlays = [
                    inputs.apple-silicon.overlays.default
                    inputs.nix-vscode-extensions.overlays.default
                  ];
                };

                specialArgs = {
                  modulesPath = inputs.nixpkgs + "/nixos/modules";
                  inputs = inputs;
                };

                modules = [
                  ./hosts/asahi/iso
                  (inputs.apple-silicon + "/iso-configuration")
                  { hardware.asahi.pkgsSystem = system; }
                  home-manager.nixosModules.home-manager
                  (self.nixosModules.users-avie { desktop = false; })
                ];
              };

              config = installer-system.config;
            in
            (config.system.build.isoImage.overrideAttrs (old: {
              # add ability to access the whole config from the command line
              passthru = (old.passthru or { }) // {
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

    home-mananm-appletger = {
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

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      flake = false;
    };

    flake-compat = {
      url = "github:nix-community/flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
  };
}
