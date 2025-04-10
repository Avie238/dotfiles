{
  description = "Avie's NixOS Flake";

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

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

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
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      flake = false;
    };

    flake-compat.url = "github:nix-community/flake-compat";

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      apple-silicon,
      nix-vscode-extensions,
      sops-nix,
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
          ];
        };

    in
    {
      nixosConfigurations = {
        avie-nixos = nixpkgs.lib.nixosSystem {
          pkgs = pkgsFor "aarch64-linux";
          modules = [
            ./hosts/asahi
            home-manager.nixosModules.home-manager
            (self.nixosModules.users-avie { desktop = true; })
          ];
          specialArgs = { inherit inputs self; };
        };

        msi-nixos = nixpkgs.lib.nixosSystem {
          pkgs = pkgsFor "x86_64-linux";
          modules = [
            ./hosts/msi
            home-manager.nixosModules.home-manager
            (self.nixosModules.users-avie { desktop = true; })
            inputs.disko.nixosModules.default
            inputs.impermanence.nixosModules.impermanence
          ];
          specialArgs = { inherit inputs self; };
        };

        msi-iso = nixpkgs.lib.nixosSystem {
          pkgs = pkgsFor "x86_64-linux";
          modules = [
            ./hosts/msi/iso
            home-manager.nixosModules.home-manager
            (self.nixosModules.users-avie { desktop = false; })
          ];
          specialArgs = { inherit inputs self; };
        };
        asahi-iso2 = nixpkgs.lib.nixosSystem {
          pkgs = pkgsFor "aarch64-linux";
          modules = [
            ./hosts/asahi/iso
            home-manager.nixosModules.home-manager
            (self.nixosModules.users-avie { desktop = false; })
          ];
          specialArgs = { inherit inputs self; };
        };

      };

      nixosModules = {

        users-avie =
          {
            desktop ? false,
            ...
          }:
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.avie = {
                imports =
                  if desktop then [ ./home-manger/users/avie/desktop ] else [ ./home-manger/users/avie/minimal ];

              };
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
}
