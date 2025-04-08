{
  description = "Avie's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";

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
      # build platforms supported for uboot in nixpkgs
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = inputs.nixpkgs.lib.genAttrs systems;

      pkgs = import nixpkgs {
        system = "aarch64-linux";
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
          modules = [
            ./hosts/asahi
            home-manager.nixosModules.home-manager
            (self.nixosModules.users-avie { desktop = true; })
          ];
          specialArgs = { inherit inputs self pkgs; };
        };

        msi-nixos = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/msi
            home-manager.nixosModules.home-manager
            (self.nixosModules.users-avie { desktop = true; })
            inputs.disko.nixosModules.default
            inputs.impermanence.nixosModules.impermanence
          ];
          specialArgs = { inherit inputs self; };
        };

        x86-iso = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/x86-iso
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

                # make sure this matches the post-install
                # `hardware.asahi.pkgsSystem`
                pkgs = import inputs.nixpkgs {
                  crossSystem.system = "aarch64-linux";
                  localSystem.system = system;
                  overlays = [ inputs.apple-silicon.overlays.default ];
                };

                specialArgs = {
                  modulesPath = inputs.nixpkgs + "/nixos/modules";
                  inputs = inputs;
                };

                modules = [
                  ./hosts/arm-iso
                  (inputs.apple-silicon + "/iso-configuration")
                  { hardware.asahi.pkgsSystem = system; }
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
