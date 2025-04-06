{
  description = "Asahi linux Nixos M2 air";

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
      # system = "aarch64-linux";
      # pkgs = import nixpkgs {
      #   inherit system;
      #   overlays = [
      #     inputs.nix-vscode-extensions.overlays.default
      #   ];
      # };
      # lib = nixpkgs.lib;

    in
    {
      nixosConfigurations = {
        avie-nixos = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/asahi
            home-manager.nixosModules.home-manager
            self.nixosModules.declarativeHome
            (self.nixosModules.users-avie { desktop = true; })
          ];
          specialArgs = { inherit inputs self; };
        };

        msi-nixos = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/msi
            home-manager.nixosModules.home-manager
            self.nixosModules.declarativeHome
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
            self.nixosModules.declarativeHome
            (self.nixosModules.users-avie { desktop = false; })
          ];
          specialArgs = { inherit inputs self; };
        };
      };

      nixosModules = {
        declarativeHome = {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        };

        users-avie =
          {
            desktop ? false,
            ...
          }:
          {
            home-manager.users.avie = {
              imports =
                if desktop then [ ./home-manger/users/avie/desktop.nix ] else [ ./home-manger/users/avie ];

            };

          };

      };

    };
}
